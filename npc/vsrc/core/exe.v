module exe (
    input  wire[`ysyx_23060251_opinfo_bus] opinfo_i,
    input  wire[`ysyx_23060251_alu_bus] alu_i,
    input  wire[`ysyx_23060251_branch_bus] branch_i,

    input  wire[`ysyx_23060251_pc_bus]  pc_i,
    input  wire[`ysyx_23060251_reg_bus] src1_i,
    input  wire[`ysyx_23060251_reg_bus] src2_i,
    input  wire[`ysyx_23060251_imm_bus] imm_i, //offset

    output wire[`ysyx_23060251_xlen_bus] res_o
);

    alu ysyx_23060251_alu (
        .opinfo_i(opinfo_i),
        .alu_i(alu_i),
        .pc_i(pc_i),
        .src1_i(src1_i),
        .src2_i(src2_i),
        .imm_i(imm_i),
        .res_o(res_o)
    );
endmodule
