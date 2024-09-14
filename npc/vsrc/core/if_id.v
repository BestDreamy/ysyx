module if_id (
	input   [`ysyx_23060251_inst_bus]       f_inst_i,
	input	[`ysyx_23060251_pc_bus]			f_pc_i,

    input                                   f_valid_i, // from ifu
    output                                  D_ready_o, // to ifu

	output  [`ysyx_23060251_inst_bus]       d_inst_o,
	output	[`ysyx_23060251_pc_bus]			d_pc_o,

    output                                  D_valid_o, // to idu
    input                                   d_ready_i, // from idu

    input 									clk_i,
    input 									rst_i
);
	pipe #(
		.DATA_WIDTH(`ysyx_23060251_inst)
	) inst_pipe (
		.clk        (clk_i),
		.rstn       (rst_i),
		.pin_valid  (f_valid_i),
		.pin_data   (f_inst_i),
		.pin_ready  (D_ready_o),
		.pout_valid (D_valid_o),
		.pout_data  (d_inst_o),
		.pout_ready (d_ready_i)
	);

	pipe #(
		.DATA_WIDTH(`ysyx_23060251_pc)
	) pc_pipe (
		.clk        (clk_i),
		.rstn       (rst_i),
		.pin_valid  (f_valid_i),
		.pin_data   (f_pc_i),
		.pin_ready  (D_ready_o),
		.pout_valid (D_valid_o),
		.pout_data  (d_pc_o),
		.pout_ready (d_ready_i)
	);

endmodule