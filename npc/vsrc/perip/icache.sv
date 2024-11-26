module icache ( 
    axi_if.Master                       axi_mst,
    input [`ysyx_23060251_pc_bus]       pc_i,

    input                               clk_i,
    input                               rst_i
);
  //1. iCache : ////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

    wire axi_ar_hs, axi_r_hs;

    localparam [3: 0] IDLE = 4'b0001,           WAIT_BUS_REQ = 4'b0010, 
                      WAIT_BUS_RSP = 4'b0100,   WAIT_ID_HS   = 4'b1000;
    reg[3: 0] state, next_state;

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
    assign axi_ar_hs = axi_mst.ar_valid & axi_mst.ar_ready;
    assign axi_r_hs  = axi_mst.r_valid  & axi_mst.r_ready;

    assign axi_mst.ar_valid = (state == WAIT_BUS_REQ);
    assign axi_mst.ar_addr  = pc_i;

    assign axi_mst.r_ready  = (state == WAIT_BUS_RSP);
    // ------------------------------  AXI  -----------------------------------

endmodule