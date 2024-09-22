module axi_Arbiter (
	input								   clk_i,
	input 								   rst_i,

    input                                  f_slv_ar_valid_i,
    input  [`ysyx_23060251_axi_addr_bus]   f_slv_ar_addr_i,
    // input  axi_id_t						   slv_ar_id_i,
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
    output                                 mst_r_ready_o
);
	localparam AXI_ARBITER_NR = 3;
	localparam [AXI_ARBITER_NR-1: 0] IDLE = 3'b1, REQ_SEL = 3'b10, RSP_SEL = 3'b100;

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
            if (f_slv_ar_valid_i & m_slv_ar_valid_i)
                next_state = REQ_SEL;
            else
                next_state = state;
        end else if (state == REQ_SEL) begin
            if (ar_hs) 
                next_state = RSP_SEL;
            else 
                next_state = state;
        end else begin // state == RSP_SEL
        	if (r_hs)
            	next_state = IDLE;
            else 
            	next_state = state;
        end
    end
    // ---------------------- state machine end -------------------------------

    // prior
    //     0    priority for ifu
    //     1    priority for lsu
    reg prior;

    always @(posedge clk_i) begin
    	if (rst_i == `ysyx_23060251_rst_enable)
    		prior <= 1'b0;
    	else if (state == RSP_SEL & next_state == IDLE)
    		prior <= ~prior;
    end

	wire arbiter;
	assign arbiter = (f_slv_ar_valid_i & m_slv_ar_valid_i)? prior:
					 f_slv_ar_valid_i | f_slv_r_ready_i? 1'b0: 1'b1;

	assign mst_ar_valid_o = (arbiter == 1'b0)? f_slv_ar_valid_i: m_slv_ar_valid_i;
	assign mst_ar_addr_o  = (arbiter == 1'b0)? f_slv_ar_addr_i : m_slv_ar_addr_i ;

	assign f_slv_ar_ready_o = (arbiter == 1'b0)? mst_ar_ready_i: 1'b0;
	assign m_slv_ar_ready_o = (arbiter == 1'b1)? mst_ar_ready_i: 1'b0;

	assign mst_r_ready_o = (arbiter == 1'b0)? f_slv_r_ready_i: m_slv_r_ready_i;

	assign f_slv_r_valid_o = (arbiter == 1'b0) & mst_r_valid_i;
	assign f_slv_r_data_o  = mst_r_data_i;
	assign f_slv_r_resp_o  = mst_r_resp_i;
	assign m_slv_r_valid_o = (arbiter == 1'b1) & mst_r_valid_i;
	assign m_slv_r_data_o  = mst_r_data_i;
	assign m_slv_r_resp_o  = mst_r_resp_i;

	assign ar_hs = mst_ar_valid_o & mst_ar_ready_i;
	assign r_hs  = mst_r_valid_i  & mst_r_ready_o;

endmodule