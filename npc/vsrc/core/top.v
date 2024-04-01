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
import "DPI-C" function bit ebreak(int inst); //type: bit int
always_comb if (ebreak(inst)) $finish();

wire[11: 0] opinfo;
wire[ 9: 0] alu_info;
wire[ 5: 0] branch_info;
wire[ 6: 0] load_info;
wire[ 3: 0] store_info;
wire[ 1: 0] sys_info;
wire        wenReg;
wire[ 4: 0] rd;
wire[ 4: 0] rs1;
wire[ 4: 0] rs2;
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
        .wenReg_o(wenReg),
        .rd_o(rd),
        .rs1_o(rs1),
        .rs2_o(rs2),
        .src1_o(src1),
        .src2_o(src2),
        .imm_o(imm)
    );

    /****************************************************************************************
                                          src && wb
    ****************************************************************************************/
    regs ysyx_23060251_regs (
        .clk_i(clk),
        .rst_i(rst),
        .wen_i(wenReg),
        .rd_i(rd),
        .wdata_i(res),

        .rs1_i(rs1),
        .src1_o(src1),
        .rs2_i(rs2),
        .src2_o(src2)
    );
wire[63: 0] res;
    exe ysyx_23060251_exe (
        .opinfo_i(opinfo),
        .alu_i(alu_info),
        .branch_i(branch_info),
        .pc_i(pc),
        .src1_i(src1),
        .src2_i(src2),
        .imm_i(imm),
        .res_o(res)
    );

/*
    wb ysyx_23060251_wb (
        .clk_i(clk),
        .rst_i(rst),
        .opinfo_i(opinfo),
        .dst_i(dst),
        .res_i(res)
    );
*/
endmodule
