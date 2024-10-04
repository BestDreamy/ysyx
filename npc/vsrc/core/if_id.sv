module if_id (
	input   [`ysyx_23060251_inst_bus]       f_inst_i,
	input	[`ysyx_23060251_pc_bus]			f_pc_i,
    input   [`ysyx_23060251_opinfo_bus]     f_opinfo_i,
    input   [`ysyx_23060251_imm_bus]        f_imm_i,
    input   [`ysyx_23060251_pc_bus]         f_pred_pc_i,

    input                                   f_valid_i, // from ifu
    output                                  D_ready_o, // to ifu

	output  [`ysyx_23060251_inst_bus]       d_inst_o,
	output	[`ysyx_23060251_pc_bus]			d_pc_o,
    output  [`ysyx_23060251_opinfo_bus]     d_opinfo_o,
    output  [`ysyx_23060251_imm_bus]        d_imm_o,
    output   [`ysyx_23060251_pc_bus]        d_pred_pc_o,

    output                                  D_valid_o, // to idu
    input                                   d_ready_i, // from idu

    input 									clk_i,
    input 									rst_i
);
	pipe if_id_pipe 
	(
		.clk        (clk_i),
		.rst        (rst_i),
		.pin_valid  (f_valid_i),
		// .pin_data   (f_inst_i),
		.pin_ready  (D_ready_o),
		.pout_valid (D_valid_o),
		// .pout_data  (d_inst_o),
		.pout_ready (d_ready_i)
	);

	wire en; // stall or bubble

	reg [`ysyx_23060251_inst_bus] D_inst;
	reg [`ysyx_23060251_pc_bus]   D_pc;

	assign en = f_valid_i & D_ready_o;

	always @(posedge clk_i) begin
		if (en) begin
			D_inst <= f_inst_i;
			D_pc   <= f_pc_i;
		end
	end

	assign d_inst_o  		= D_valid_o? D_inst: `ysyx_23060251_inst'h13;
	assign d_pc_o    		= {`ysyx_23060251_pc{D_valid_o}}   & D_pc;
	assign d_opinfo_o		= f_opinfo_i;
	assign d_imm_o			= f_imm_i;
	assign d_pred_pc_o 		= f_pred_pc_i;

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