`include "defines"
module top (
    input clk,
    input rst,
    output wire[`ysyx_23060251_pc_bus]   pc,
    output wire[`ysyx_23060251_inst_bus] inst
);

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

    import "DPI-C" function bit halt(int inst); //type: bit int
    always_comb if (halt(inst)) $finish();

wire[`ysyx_23060251_opinfo_bus] opinfo;
wire[`ysyx_23060251_alu_bus] alu_info;
wire[`ysyx_23060251_branch_bus] branch_info;
wire[`ysyx_23060251_load_bus] load_info;
wire[`ysyx_23060251_store_bus] store_info;
wire[`ysyx_23060251_sys_bus] sys_info;
wire        wenReg;
wire[`ysyx_23060251_rs_bus] rd;
wire[`ysyx_23060251_rs_bus] rs1;
wire[`ysyx_23060251_rs_bus] rs2;
wire[`ysyx_23060251_reg_bus] src1;
wire[`ysyx_23060251_reg_bus] src2;
wire[`ysyx_23060251_imm_bus] imm;
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
wire[`ysyx_23060251_xlen_bus] res;
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
