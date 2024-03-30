`include "defines"
module top (
    input clk,
    input rst
);

wire[63: 0] pc;
wire[31: 0] inst;
    pcReg ysyx_23060251_pcReg (
        .clk_i(clk),
        .rst_i(rst),
        .pc_o(pc)
    );

    ifu ysyx_23060251_ifu (
        .clk_i(clk),
        .rst_i(rst),
        .pc_i(pc),
        .inst_o(inst)
    );

wire[11: 0] opinfo;
wire[ 9: 0] alu_info;
wire[ 5: 0] branch_info;
wire[ 6: 0] load_info;
wire[ 3: 0] store_info;
wire[ 1: 0] sys_info;
wire[63: 0] src1;
wire[63: 0] src2;
wire[63: 0] imm;
    idu ysyx_23060251_idu (
        .inst_i(inst),
        .opinfo_o(opinfo),
        .alu_o(alu_info),
        .branch_o(branch_info),
        .load_o(load_info),
        .store_o(store_info),
        .sys_o(sys_info),
        .src1_o(src1),
        .src2_o(src2),
        .imm_o(imm)
    );
endmodule
