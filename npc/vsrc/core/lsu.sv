module lsu (
    input                                   clk_i,
    input                                   rst_i,
    input                                   is_load_signed_i,
    input                                   wenMem_i,
    input                                   renMem_i,
    // input  [`ysyx_23060251_store_bus] store_info_i,
    // input  [`ysyx_23060251_load_bus] load_info_i,
    input  [`ysyx_23060251_xlen_bus]        addr_i,
    input  [`ysyx_23060251_mask_bus]        mask_i,
    input  [`ysyx_23060251_xlen_bus]        wdata_i,

    input                                   M_valid_i, // from exu
    output                                  m_ready_o, // from exu

    output                                  wb_en,

    output [`ysyx_23060251_xlen_bus]        rdata_o,

    // AXI LITE
    output                                  mst_ar_valid_o,
    output  [`ysyx_23060251_axi_addr_bus]   mst_ar_addr_o,
    input                                   mst_ar_ready_i,

    input                                   mst_r_valid_i,
    input   [`ysyx_23060251_axi_data_bus]   mst_r_data_i,
    input   axi_resp_t                      mst_r_resp_i,
    output                                  mst_r_ready_o,

    output                                  mst_aw_valid_o,
    output  [`ysyx_23060251_axi_addr_bus]   mst_aw_addr_o,
    input                                   mst_aw_ready_i,

    output                                  mst_w_valid_o,
    output  [`ysyx_23060251_axi_data_bus]   mst_w_data_o,
    output  [`ysyx_23060251_axi_strb_bus]   mst_w_strb_o,
    input                                   mst_w_ready_i,

    input                                   mst_b_valid_i,
    input   axi_resp_t                      mst_b_resp_i,
    output                                  mst_b_ready_o
);
// always_comb $display("lsu state: %h\n", state);
    localparam [6: 0] IDLE = 7'h1;
    localparam [6: 0] WAIT_AR_REQ = 7'h2 , WAIT_R_RSP = 7'h4 , WAIT_WB    = 7'h8 ;
    localparam [6: 0] WAIT_AW_REQ = 7'h10, WAIT_W_REQ = 7'h20, WAIT_B_RSP = 7'h40;

    reg[6: 0] state, next_state;

    wire rx_valid, r_en, w_en, mem_dis;

    wire ar_hs, r_hs, aw_hs, w_hs, b_hs;

    // --------------------------- state machine ----------------------------
    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        if (state == IDLE) begin
            if (r_en)
                next_state = WAIT_AR_REQ;
            else if (w_en)
                next_state = WAIT_AW_REQ;
            else if (mem_dis)
                next_state = WAIT_WB;
            else
                next_state = state;
        end else if (state == WAIT_AR_REQ) begin
            if (ar_hs) 
                next_state = WAIT_R_RSP;
            else 
                next_state = state;
        end else if (state == WAIT_R_RSP) begin
            if (r_hs)
                next_state = WAIT_WB;
            else 
                next_state = state;
        end else if (state == WAIT_AW_REQ) begin
            if (aw_hs) 
                next_state = WAIT_W_REQ;
            else 
                next_state = state;
        end else if (state == WAIT_W_REQ) begin
            if (w_hs)
                next_state = WAIT_B_RSP;
            else 
                next_state = state;
        end else if (state == WAIT_B_RSP) begin
            if (b_hs)
                next_state = IDLE;
            else 
                next_state = state;
        end else begin // state == WAIT_WB
            next_state = IDLE;
        end
    end
    // ---------------------- state machine end -------------------------------

    assign m_ready_o = (state == IDLE);
    assign rx_valid = M_valid_i & m_ready_o;
    assign r_en     = rx_valid & renMem_i;
    assign w_en     = rx_valid & wenMem_i;
    assign mem_dis  = rx_valid & (~renMem_i) & (~wenMem_i);

    // ------------------------------  AXI  -----------------------------------
    assign mst_ar_valid_o = (state == WAIT_AR_REQ);
    assign mst_ar_addr_o  = addr_i;

    assign mst_r_ready_o  = (state == WAIT_R_RSP);

    assign mst_aw_valid_o = (state == WAIT_AW_REQ);
    assign mst_aw_addr_o  = addr_i;

    assign mst_w_valid_o  = (state == WAIT_W_REQ);
    assign mst_w_data_o   = wdata_i;
    assign mst_w_strb_o   = mask_i;

    assign mst_b_ready_o  = (state == WAIT_B_RSP);

    assign ar_hs = mst_ar_valid_o & mst_ar_ready_i;
    assign r_hs  = mst_r_valid_i  & mst_r_ready_o;
    assign aw_hs = mst_aw_valid_o & mst_aw_ready_i;
    assign w_hs  = mst_w_valid_o  & mst_w_ready_i;
    assign b_hs  = mst_b_valid_i  & mst_b_ready_o;  
    // ------------------------------  AXI  -----------------------------------

    assign wb_en = (state == WAIT_WB);

    // import "DPI-C" function int vaddr_read(
    //     bit is_signed,
    //     int addr,
    //     byte mask
    // );
    // always_comb begin
    //     if (renMem_i) rdata_o = vaddr_read(is_load_signed_i, addr_i, mask_i);
    //     else rdata_o = 0;
    // end

    // import "DPI-C" function void vaddr_write(
    //     int addr,
    //     byte mask,
    //     int data
    // );
    // always @(posedge clk_i) begin
    //     if (wenMem_i) vaddr_write(addr_i, mask_i, wdata_i);
    // end
endmodule