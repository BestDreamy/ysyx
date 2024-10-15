module ex_ls (
`ifdef ITRACE
    input  [`ysyx_23060251_inst_bus]       e_inst_i,
`endif
    input  [`ysyx_23060251_sys_bus]        e_sys_info_i,
    input                                  e_wenReg_i,
    input                                  e_wenCsr_i,
    input  [`ysyx_23060251_rs_bus]         e_rd_i,
    input  [`ysyx_23060251_reg_bus]        e_src1_i,
    input  [`ysyx_23060251_reg_bus]        e_src2_i,
    input  [`ysyx_23060251_imm_bus]        e_imm_i,
    input                                  e_is_load_signed_i,
    input                                  e_wenMem_i,
    input                                  e_renMem_i,
    input  [`ysyx_23060251_mask_bus]       e_mask_i,
    input  [`ysyx_23060251_pc_bus]         e_npc_i,
    input  [`ysyx_23060251_xlen_bus]       e_res_i,
    input                                  e_cnd_i,

    input                                  e_valid_i, // from exu
    output                                 M_ready_o, // to exu

`ifdef ITRACE
    output  [`ysyx_23060251_inst_bus]      m_inst_o,
`endif
    output  [`ysyx_23060251_sys_bus]       m_sys_info_o,
    output                                 m_wenReg_o,
    output                                 m_wenCsr_o,
    output  [`ysyx_23060251_rs_bus]        m_rd_o,
    output  [`ysyx_23060251_reg_bus]       m_src1_o,
    output  [`ysyx_23060251_reg_bus]       m_src2_o,
    output  [`ysyx_23060251_imm_bus]       m_imm_o,
    output                                 m_is_load_signed_o,
    output                                 m_wenMem_o,
    output                                 m_renMem_o,
    output  [`ysyx_23060251_mask_bus]      m_mask_o,
    output  [`ysyx_23060251_pc_bus]        m_npc_o,
    output  [`ysyx_23060251_xlen_bus]      m_res_o,
    output                                 m_cnd_o,

    output                                 M_valid_o,
    input                                  m_ready_i,

    input                                  clk_i,
    input                                  rst_i
);

    pipe ex_ls_pipe 
	(
		.clk        (clk_i),
		.rst        (rst_i),
		.pin_valid  (e_valid_i),
		.pin_ready  (M_ready_o),
		.pout_valid (M_valid_o),
		.pout_ready (m_ready_i)
	);

    wire en; // stall or bubble

    reg  [`ysyx_23060251_sys_bus]       M_sys_info;
    reg                                 M_wenReg;
    reg                                 M_wenCsr;
    reg  [`ysyx_23060251_rs_bus]        M_rd;
    reg  [`ysyx_23060251_reg_bus]       M_src1;
    reg  [`ysyx_23060251_reg_bus]       M_src2;
    reg  [`ysyx_23060251_imm_bus]       M_imm;
    reg                                 M_is_load_signed;
    reg                                 M_wenMem;
    reg                                 M_renMem;
    reg  [`ysyx_23060251_mask_bus]      M_mask;
    reg  [`ysyx_23060251_pc_bus]        M_npc;
    reg  [`ysyx_23060251_xlen_bus]      M_res;
    reg                                 M_cnd;
`ifdef ITRACE
    reg [`ysyx_23060251_inst_bus]       M_inst;
`endif

    assign en = e_valid_i & M_ready_o;

    always @(posedge clk_i) begin
        if (en) begin
            M_sys_info          <= e_sys_info_i;
            M_wenReg            <= e_wenReg_i;
            M_wenCsr            <= e_wenCsr_i;
            M_rd                <= e_rd_i;
            M_src1              <= e_src1_i;
            M_src2              <= e_src2_i;
            M_imm               <= e_imm_i;
            M_is_load_signed    <= e_is_load_signed_i;
            M_wenMem            <= e_wenMem_i;
            M_renMem            <= e_renMem_i;
            M_mask              <= e_mask_i;
            M_npc               <= e_npc_i;
            M_res               <= e_res_i;
            M_cnd               <= e_cnd_i;
`ifdef ITRACE
            M_inst              <= e_inst_i;
`endif
        end
    end

    assign m_sys_info_o          = M_sys_info;
    assign m_wenReg_o            = M_wenReg;
    assign m_wenCsr_o            = M_wenCsr;
    assign m_rd_o                = M_rd;
    assign m_src1_o              = M_src1;
    assign m_src2_o              = M_src2;
    assign m_imm_o               = M_imm;
    assign m_is_load_signed_o    = M_is_load_signed;
    assign m_wenMem_o            = M_wenMem;
    assign m_renMem_o            = M_renMem;
    assign m_mask_o              = M_mask;
    assign m_npc_o               = M_npc;
    assign m_res_o               = M_res;
    assign m_cnd_o               = M_cnd;
`ifdef ITRACE
    assign m_inst_o              = M_inst;
`endif
endmodule
