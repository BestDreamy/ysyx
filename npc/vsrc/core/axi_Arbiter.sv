module axi_Arbiter (
    input                                  f_slv_ar_valid_i,
    input  [`ysyx_23060251_axi_addr_bus]   f_slv_ar_addr_i,
    // input  axi_id_t                         slv_ar_id_i,
    output                                 f_slv_ar_ready_o,

    input                                  m_slv_ar_valid_i,
    input  [`ysyx_23060251_axi_addr_bus]   m_slv_ar_addr_i,
    output                                 m_slv_ar_ready_o,

    output                                 f_slv_r_valid_o,
    output [`ysyx_23060251_axi_data_bus]   f_slv_r_data_o,
    output axi_resp_t                      f_slv_r_resp_o,
    input                                  f_slv_r_ready_i,

    output                                 m_slv_r_valid_o,
    output [`ysyx_23060251_axi_data_bus]   m_slv_r_data_o,
    output axi_resp_t                      m_slv_r_resp_o,
    input                                  m_slv_r_ready_i,

    output                                 mst_ar_valid_o,
    output  [`ysyx_23060251_axi_addr_bus]  mst_ar_addr_o,
    input                                  mst_ar_ready_i,

    input                                  mst_r_valid_i,
    input   [`ysyx_23060251_axi_data_bus]  mst_r_data_i,
    input   axi_resp_t                     mst_r_resp_i,
    output                                 mst_r_ready_o,

// W Channel
// -----------------------------------------------------------------------
    input                                  m_slv_aw_valid_i,
    input  [`ysyx_23060251_axi_addr_bus]   m_slv_aw_addr_i,
    output                                 m_slv_aw_ready_o,

    input                                  m_slv_w_valid_i,
    input  [`ysyx_23060251_axi_data_bus]   m_slv_w_data_i,
    input  [`ysyx_23060251_axi_strb_bus]   m_slv_w_strb_i,
    output                                 m_slv_w_ready_o,

    output                                 m_slv_b_valid_o,
    output axi_resp_t                      m_slv_b_resp_o,
    input                                  m_slv_b_ready_i,

    output                                 mst_aw_valid_o,
    output  [`ysyx_23060251_axi_addr_bus]  mst_aw_addr_o,
    input                                  mst_aw_ready_i,

    output                                 mst_w_valid_o,
    output  [`ysyx_23060251_axi_data_bus]  mst_w_data_o,
    output  [`ysyx_23060251_axi_strb_bus]  mst_w_strb_o,
    input                                  mst_w_ready_i,

    input                                  mst_b_valid_i,
    input   axi_resp_t                     mst_b_resp_i,
    output                                 mst_b_ready_o,

    input                                  clk_i,
    input                                  rst_i
);
    localparam AXI_ARBITER_NR = 4;
    localparam [AXI_ARBITER_NR-1: 0] IDLE = 4'b1, CHAN_SEL = 4'b10, RD_REQ = 4'b100, RD_RSP = 4'b1000;

    reg [AXI_ARBITER_NR-1: 0] state, next_state;
    wire ar_hs, r_hs;

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
            if (f_slv_ar_valid_i | m_slv_ar_valid_i)
                next_state = CHAN_SEL;
            else
                next_state = state;
        end else if (state == CHAN_SEL) begin
            next_state = RD_REQ;
        end else if (state == RD_REQ) begin
            if (ar_hs)
                next_state = RD_RSP;
            else 
                next_state = state;
        end else begin // state == RD_RSP
            if (r_hs)
                next_state = IDLE;
            else 
                next_state = state;
        end
    end
    // ---------------------- state machine end -------------------------------

    // prior
    // ~(last channel select)
    //     0    priority for ifu
    //     1    priority for lsu
    reg prior;

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable)
            prior <= 1'b0;
        else if (state == RD_REQ)
            prior <= ~arbiter;
    end

    reg arbiter;
    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable)
            arbiter <= 1'b0;
        else if (state == CHAN_SEL) begin
            if (f_slv_ar_valid_i & m_slv_ar_valid_i)
                arbiter <= prior;
            else if (f_slv_ar_valid_i)
                arbiter <= 1'b0;
            else 
                arbiter <= 1'b1;
        end
    end

    assign mst_ar_valid_o = (state == RD_REQ)? ((arbiter == 1'b0)? f_slv_ar_valid_i: m_slv_ar_valid_i): 1'b0;
    assign mst_ar_addr_o  = (arbiter == 1'b0)? f_slv_ar_addr_i : m_slv_ar_addr_i ;

    assign f_slv_ar_ready_o = (state == RD_REQ)? mst_ar_ready_i: 1'b0;
    assign m_slv_ar_ready_o = (state == RD_REQ)? mst_ar_ready_i: 1'b0;

    assign mst_r_ready_o = (state == RD_RSP)? ((arbiter == 1'b0)? f_slv_r_ready_i: m_slv_r_ready_i): 1'b0;

    assign f_slv_r_valid_o = (state == RD_RSP) & mst_r_valid_i;
    assign f_slv_r_data_o  = mst_r_data_i;
    assign f_slv_r_resp_o  = mst_r_resp_i;
    assign m_slv_r_valid_o = (state == RD_RSP) & mst_r_valid_i;
    assign m_slv_r_data_o  = mst_r_data_i;
    assign m_slv_r_resp_o  = mst_r_resp_i;

    assign ar_hs = mst_ar_valid_o & mst_ar_ready_i;
    assign r_hs  = mst_r_valid_i  & mst_r_ready_o;


// W Channel 
// --------------------------------------------------------------------------------
    // assign mst_aw = m_slv_aw;
    `AXI_ASSIGN_AW(mst_, _, _o, m_slv_, _, _i)
    // assign mst_w = m_slv_w;
    `AXI_ASSIGN_W(mst_, _, _o, m_slv_, _, _i)
    // assign m_slv_b = mst_b;
    `AXI_ASSIGN_B(m_slv_, _, _o, mst_, _, _i)

endmodule