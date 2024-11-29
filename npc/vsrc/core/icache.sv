module icache ( 
    axi_ar_if                           axi_mst_ar,
    axi_r_if                            axi_mst_r,
    input [`ysyx_23060251_pc_bus]       pc_i,
    input                               ifu2Dpipe_en_i,
    input                               f_stall_i,
    input                               ifu_sleep_i,

    output [`ysyx_23060251_inst_bus]    inst_o,
    output                              f_valid_o,

    input                               clk_i,
    input                               rst_i
);
  //1. iCache : 

  //          |<------16 bytes---->| 
  //   ⌈‾‾‾‾‾⌉ ⌈‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾⌉ --
  //   |     | |                    | |
  //   |     | |                    | |
  //   |     | |                    | |
  //   |     | |                    | |
  //   | Tag | |     Cacheline      | 128 sets
  //   |     | |                    | |
  //   |     | |                    | |
  //   |     | |                    | |
  //   |     | |                    | |
  //   ⌊_____⌋ ⌊____________________⌋ --

    localparam int OFFSET_NUM = 4, SET_NUM = 128;
    localparam int TAG_W = `ysyx_23060251_xlen - $clog2(OFFSET_NUM) - $clog2(SET_NUM);
    reg [TAG_W-1: 0]                    tagarray [SET_NUM];
    reg [`ysyx_23060251_byte_bus]       dataarray[SET_NUM][OFFSET_NUM];
    reg [SET_NUM-1: 0]                  valarray ;

    wire [$clog2(SET_NUM)-1: 0]     set_addr;
    wire [$clog2(OFFSET_NUM)-1: 0]  offset_addr;
    wire [TAG_W-1: 0]               tag_in;

    wire axi_ar_hs, axi_r_hs;

    localparam [4: 0] IDLE = 5'b1, WAIT_BUS_REQ = 5'b10, WAIT_BUS_RSP = 5'b100, 
                      WAIT_ID_HS = 5'b1000, READ_CACHE = 5'b1_0000;
    reg[4: 0] state, next_state;

    assign f_valid_o = (state == WAIT_ID_HS);

    // ---------------------- read state machine ----------------------------
    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        if (state == IDLE) begin
            if (f_stall_i)
                next_state = state; // IDLE
            else
                next_state = READ_CACHE;
        end else if (state == READ_CACHE) begin
            if (cache_hit)
                next_state = WAIT_ID_HS;
            else 
                next_state = WAIT_BUS_REQ;
        end else if (state == WAIT_BUS_REQ) begin
            if (axi_ar_hs)
                next_state = WAIT_BUS_RSP;
            else
                next_state = state;
        end else if (state == WAIT_BUS_RSP) begin
            if (axi_r_hs)
                next_state = WAIT_ID_HS;
            else
                next_state = state;
        end else begin // state == WAIT_ID_HS
            if (ifu2Dpipe_en_i)
                // 1. jalr     (IDLE) wait decode bypass for one cycle   [need stall]
                // 2. csr      (IDLE) wait decode bypass for one cycle   [need stall]
                // 3. branch   (READ INST) check condition in execute [need bubble maybe]
                // 4. other    (READ INST) accept
                if (ifu_sleep_i)
                    next_state = IDLE;
                else
                    next_state = READ_CACHE;
            else
                next_state = state;
        end
    end
    // ---------------------- state machine end -------------------------------

    // ------------------------------  AXI  -----------------------------------
    assign axi_ar_hs = axi_mst_ar.ar_valid & axi_mst_ar.ar_ready;
    assign axi_r_hs  = axi_mst_r.r_valid  & axi_mst_r.r_ready;

    assign axi_mst_ar.ar_valid = (state == WAIT_BUS_REQ);
    assign axi_mst_ar.ar_addr  = pc_i;

    assign axi_mst_r.r_ready  = (state == WAIT_BUS_RSP);
    // ------------------------------  AXI  -----------------------------------

    // --------------------------  cache access -------------------------------
    // direct mapping
    assign {
        tag_in,
        set_addr,
        offset_addr
    } = pc_i; 

    wire cache_rd_en  = (state == READ_CACHE);
    wire cache_hit    = cache_rd_en & (tag_in == tagarray[set_addr]) & valarray[set_addr];
    wire [`ysyx_23060251_inst_bus] data_qw = {
                        dataarray[set_addr][offset_addr + 3], dataarray[set_addr][offset_addr + 2],
                        dataarray[set_addr][offset_addr + 1], dataarray[set_addr][offset_addr]
                    };
    // --------------------------  cache access -------------------------------

    // --------------------------  cache initial ------------------------------
    always @(posedge clk_i) begin
        if (rst_i) begin
            valarray <= 0;
        end else if (axi_r_hs) begin
            valarray[set_addr] <= 1'b1;
        end
    end

    always @(posedge clk_i) begin
        if (axi_r_hs) begin
            tagarray[set_addr] <= tag_in;
        end
    end

    genvar i;
    generate
        for (i = 0; i < OFFSET_NUM; i = i + 1) begin 
            always @(posedge clk_i) begin
                if (axi_r_hs) begin
                    dataarray[set_addr][i] <= axi_mst_r.r_data[(i + 1) * 8 - 1: i * 8];
                end
            end
        end
    endgenerate
    // --------------------------  cache initial ------------------------------

    reg [`ysyx_23060251_inst_bus] inst;
    assign inst_o = inst;

    always @(posedge clk_i) begin
        if (rst_i) begin
            inst <= `ysyx_23060251_inst'h13;
        end else if (axi_r_hs) begin
            inst <= axi_mst_r.r_data[`ysyx_23060251_inst_bus];
        end else if (cache_hit) begin
            inst <= data_qw;
        end
    end

    import "DPI-C" function void halt(int inst);

    always_comb halt(inst_o);
endmodule
