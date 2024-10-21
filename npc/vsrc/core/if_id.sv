module if_id (
	input   [`ysyx_23060251_inst_bus]       f_inst_i,
	input	[`ysyx_23060251_pc_bus]			f_pc_i,
    input   [`ysyx_23060251_opinfo_bus]     f_opinfo_i,
    input   [`ysyx_23060251_imm_bus]        f_imm_i,
    input   [`ysyx_23060251_pc_bus]         f_pred_pc_i,
	input   [`ysyx_23060251_sys_bus]        f_sys_info_i,

	input									e_byp_en_i,
	input 									e_byp_cnd_i,

    input                                   f_valid_i, // from ifu
    output                                  D_ready_o, // to if

	output  [`ysyx_23060251_inst_bus]       d_inst_o,
	output	[`ysyx_23060251_pc_bus]			d_pc_o,
    output  [`ysyx_23060251_opinfo_bus]     d_opinfo_o,
    output  [`ysyx_23060251_imm_bus]        d_imm_o,
    output  [`ysyx_23060251_pc_bus]         d_pred_pc_o,
	output  [`ysyx_23060251_sys_bus]        d_sys_info_o,

    output                                  D_valid_o, // to idu
    input                                   d_ready_i, // from idu

    input 									clk_i,
    input 									rst_i
);
	wire f_valid;

	assign f_valid = f_valid_i & e_byp_en_i & ~e_byp_cnd_i;

	pipe if_id_pipe 
	(
		.clk        (clk_i),
		.rst        (rst_i),
		.pin_valid  (f_valid), 		// just for branch 
		.pin_ready  (D_ready_o),
		.pout_valid (D_valid_o),
		.pout_ready (d_ready_i)
	);

	wire en; // stall or bubble

	reg [`ysyx_23060251_inst_bus] 		D_inst;
	reg [`ysyx_23060251_pc_bus]   		D_pc;
	reg [`ysyx_23060251_opinfo_bus]		D_opinfo;
	reg [`ysyx_23060251_imm_bus]		D_imm;
	reg [`ysyx_23060251_pc_bus]   		D_pred_pc;
	reg [`ysyx_23060251_sys_bus] 		D_sys_info;

	assign en = f_valid & D_ready_o;

	always @(posedge clk_i) begin
		if (en) begin
			D_inst 		<= f_inst_i;
			D_pc   		<= f_pc_i;
			D_opinfo 	<= f_opinfo_i;
			D_imm   	<= f_imm_i;
			D_pred_pc   <= f_pred_pc_i;
			D_sys_info  <= f_sys_info_i;
		end
	end

	assign d_inst_o  		= D_valid_o? D_inst: `ysyx_23060251_inst'h13;
	assign d_pc_o    		= {`ysyx_23060251_pc{D_valid_o}} & D_pc;
	assign d_opinfo_o		= D_opinfo;
	assign d_imm_o			= D_imm;
	assign d_pred_pc_o 		= D_pred_pc;
	assign d_sys_info_o     = D_sys_info;

	// pipe #(
	// 	.DATA_WIDTH(`ysyx_23060251_pc)
	// ) pc_pipe (
	// 	.clk        (clk_i),
	// 	.rstn       (rst_i),
	// 	.pin_valid  (f_valid_i),
	// 	.pin_data   (f_pc_i),
	// 	.pin_ready  (D_ready_o),
	// 	.pout_valid (D_valid_o),
	// 	.pout_data  (d_pc_o),
	// 	.pout_ready (d_ready_i)
	// );

endmodule