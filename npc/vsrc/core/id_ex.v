module id_ex (
    input  [`ysyx_23060251_opinfo_bus]     d_opinfo_i,
    input  [`ysyx_23060251_alu_bus]        d_alu_info_i,
    input  [`ysyx_23060251_branch_bus]     d_branch_info_i,
    input  [`ysyx_23060251_sys_bus]        d_sys_info_i,
    input                                  d_wenReg_i,
    input                                  d_wenCsr_i,
    input  [`ysyx_23060251_reg_bus]        d_csr_data_i,
    input  [`ysyx_23060251_rs_bus]         d_rd_i,
    input  [`ysyx_23060251_reg_bus]        d_src1_i,
    input  [`ysyx_23060251_reg_bus]        d_src2_i,
    input  [`ysyx_23060251_imm_bus]        d_imm_i,
    input                                  d_is_load_signed_i,
    input                                  d_wenMem_i,
    input                                  d_renMem_i,
    input  [`ysyx_23060251_mask_bus]       d_mask_i,
    input  [`ysyx_23060251_pc_bus]         d_pc_i,

    input                                  d_valid_i, // from idu
    output                                 E_ready_o, // to idu

    output [`ysyx_23060251_opinfo_bus]     e_opinfo_o,
    output [`ysyx_23060251_alu_bus]        e_alu_info_o,
    output [`ysyx_23060251_branch_bus]     e_branch_info_o,
    output [`ysyx_23060251_sys_bus]        e_sys_info_o,
    output                                 e_wenReg_o,
    output                                 e_wenCsr_o,
    output [`ysyx_23060251_reg_bus]        e_csr_data_o,
    output [`ysyx_23060251_rs_bus]         e_rd_o,
    output [`ysyx_23060251_reg_bus]        e_src1_o,
    output [`ysyx_23060251_reg_bus]        e_src2_o,
    output [`ysyx_23060251_imm_bus]        e_imm_o,
    output                                 e_is_load_signed_o,
    output                                 e_wenMem_o,
    output                                 e_renMem_o,
    output [`ysyx_23060251_mask_bus]       e_mask_o,
    output [`ysyx_23060251_pc_bus]         e_pc_o,

    output                                 E_valid_o, // to exu
    input                                  e_ready_i, // from exu

    input   							   clk_i,
    input 								   rst_i
);

    pipe id_ex_pipe 
	(
		.clk        (clk_i),
		.rst        (rst_i),
		.pin_valid  (d_valid_i),
		.pin_ready  (E_ready_o),
		.pout_valid (E_valid_o),
		.pout_ready (e_ready_i)
	);

    wire en; // stall or bubble

    reg [`ysyx_23060251_opinfo_bus]     E_opinfo;
    reg [`ysyx_23060251_alu_bus]        E_alu_info;
    reg [`ysyx_23060251_branch_bus]     E_branch_info;
    reg [`ysyx_23060251_sys_bus]        E_sys_info;
    reg                                 E_wenReg;
    reg                                 E_wenCsr;
    reg [`ysyx_23060251_reg_bus]        E_csr_data;
    reg [`ysyx_23060251_rs_bus]         E_rd;
    reg [`ysyx_23060251_reg_bus]        E_src1;
    reg [`ysyx_23060251_reg_bus]        E_src2;
    reg [`ysyx_23060251_imm_bus]        E_imm;
    reg                                 E_is_load_signed;
    reg                                 E_wenMem;
    reg                                 E_renMem;
    reg [`ysyx_23060251_mask_bus]       E_mask;
    reg [`ysyx_23060251_pc_bus]         E_pc;

	assign en = d_valid_i & E_ready_o;

	always @(posedge clk_i) begin
		if (en) begin
			E_opinfo            <= d_opinfo_i;
			E_alu_info          <= d_alu_info_i;
            E_branch_info       <= d_branch_info_i;
            E_sys_info          <= d_sys_info_i;
            E_wenReg            <= d_wenReg_i;
            E_wenCsr            <= d_wenCsr_i;
            E_csr_data          <= d_csr_data_i;
            E_rd                <= d_rd_i;
            E_src1              <= d_src1_i;
            E_src2              <= d_src2_i;
            E_imm               <= d_imm_i;
            E_is_load_signed    <= d_is_load_signed_i;
            E_wenMem            <= d_wenMem_i;
            E_renMem            <= d_renMem_i;
            E_mask              <= d_mask_i;
            E_pc                <= d_pc_i;
		end
	end

    assign e_opinfo_o           = E_opinfo;
    assign e_alu_info_o         = E_alu_info;
    assign e_branch_info_o      = E_branch_info;
    assign e_sys_info_o         = E_sys_info;
    assign e_wenReg_o           = E_wenReg;
    assign e_wenCsr_o           = E_wenCsr;
    assign e_csr_data_o         = E_csr_data;
    assign e_rd_o               = E_rd;
    assign e_src1_o             = E_src1;
    assign e_src2_o             = E_src2;
    assign e_imm_o              = E_imm;
    assign e_is_load_signed_o   = E_is_load_signed;
    assign e_wenMem_o           = E_wenMem;
    assign e_renMem_o           = E_renMem;
    assign e_mask_o             = E_mask;
    assign e_pc_o               = E_pc;
endmodule
