module ifu (
    input                                   clk_i,
    input                                   rst_i,
    input   [`ysyx_23060251_pc_bus]         npc_i,

    output                                  f_valid_o, // to D
    input                                   D_ready_i, // form D

    output  [`ysyx_23060251_pc_bus]         pc_o,
    output  [`ysyx_23060251_inst_bus]       inst_o,
    output  [`ysyx_23060251_opinfo_bus]     opinfo_o,
    output  [`ysyx_23060251_sys_bus]        sys_info_o,
    output  [`ysyx_23060251_imm_bus]        imm_o,
    output  [`ysyx_23060251_pc_bus]         pred_pc_o,

    input                                   d_byp_en_i,
    input   [`ysyx_23060251_pc_bus]         d_byp_npc_i,

    // AXI LITE
    output                                  mst_ar_valid_o,
    output  [`ysyx_23060251_axi_addr_bus]   mst_ar_addr_o,
    input                                   mst_ar_ready_i,

    input                                   mst_r_valid_i,
    input   [`ysyx_23060251_axi_data_bus]   mst_r_data_i,
    input   [1:0]                           mst_r_resp_i,
    output                                  mst_r_ready_o
);
    wire is_jalr, is_mret, is_ecall;

    bjp ysyx_bjp
    (
        .opinfo_o  (opinfo_o),
        .sys_info_o(sys_info_o),
        .imm_o     (imm_o),
        .pred_pc_o (pred_pc_o),
        .inst_i    (inst_o),
        .pc_i      (pc_o)
    );

    assign is_jalr   = opinfo_o[`ysyx_23060251_opinfo_jalr];
    assign is_ecall  = sys_info_o[`ysyx_23060251_sys_ecall];
    assign is_mret   = sys_info_o[`ysyx_23060251_sys_mret];

    wire wait_decode_en;

    reg stall;
    reg bubble;

    localparam [3: 0] IDLE = 4'b0001,           WAIT_BUS_REQ = 4'b0010, 
                      WAIT_BUS_RSP = 4'b0100,   WAIT_ID_HS   = 4'b1000;
    reg[3: 0] state, next_state;

    reg[`ysyx_23060251_pc_bus]   pc;
    reg[`ysyx_23060251_inst_bus] inst;

    wire tx_valid; // ifu --> idu

    wire ar_hs, r_hs;

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
            if (stall)
                next_state = state; // IDLE
            else
                next_state = WAIT_BUS_REQ;
        end else if (state == WAIT_BUS_REQ) begin
            if (ar_hs)
                next_state = WAIT_BUS_RSP;
            else
                next_state = state;
        end else if (state == WAIT_BUS_RSP) begin
            if (r_hs)
                next_state = WAIT_ID_HS;
            else
                next_state = state;
        end else begin // state == WAIT_ID_HS
            if (tx_valid)
                // 1. jalr     (IDLE) wait decode bypass for one cycle   [need stall]
                // 2. csr      (IDLE) wait decode bypass for one cycle   [need stall]
                // 3. branch   (WAIT_BUS_REQ) check condition in execute [need bubble maybe]
                // 4. other    (WAIT_BUS_REQ) accept
                if (wait_decode_en)
                    next_state = IDLE;
                else
                    next_state = WAIT_BUS_REQ;
            else
                next_state = state;
        end
    end
    // ---------------------- state machine end -------------------------------

    // ------------------------------  AXI  -----------------------------------
    assign ar_hs = mst_ar_valid_o & mst_ar_ready_i;
    assign r_hs  = mst_r_valid_i  & mst_r_ready_o ;

    assign mst_ar_valid_o = (state == WAIT_BUS_REQ);
    assign mst_ar_addr_o  = pc_o;

    assign mst_r_ready_o  = (state == WAIT_BUS_RSP);
    // ------------------------------  AXI  -----------------------------------

    assign pc_o = pc;

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable)
            pc <= `ysyx_23060251_pc'h8000_0000;
        else if (d_byp_en_i)
            pc <= d_byp_npc_i;
        else if (tx_valid)
            pc <= pred_pc_o;
    end

    assign f_valid_o = (state == WAIT_ID_HS);
    assign tx_valid  = f_valid_o & D_ready_i;
    assign inst_o    = inst;

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable) 
            stall <= 1'b0;
        else if (wait_decode_en)
            stall <= 1'b1;
        else if (d_byp_en_i)
            stall <= 1'b0;
    end

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable)
            inst <= `ysyx_23060251_inst'h13;
        else if (r_hs) begin
            inst <= mst_r_data_i;
        end
    end

    // rom ysyx_23060251_rom (
    //     .clk_i(clk_i),
    //     .rst_i(rst_i),
    //     .pc_i(pc_o),
    //     .inst_o(mst_r_data_i)
    // );

    import "DPI-C" function void halt(int inst);

    always_comb halt(inst_o);

endmodule
