module exe (
    input  wire[`ysyx_23060251_opinfo_bus] opinfo_i,
    input  wire[`ysyx_23060251_alu_bus] alu_i,
    input  wire[`ysyx_23060251_branch_bus] branch_i,

    input  wire[`ysyx_23060251_pc_bus]  pc_i,
    input  wire[`ysyx_23060251_reg_bus] op1_i,
    input  wire[`ysyx_23060251_reg_bus] op2_i,
    input  wire[`ysyx_23060251_imm_bus] imm_i, //offset

    output wire[`ysyx_23060251_xlen_bus] res_o
);

    alu ysyx_23060251_alu (

    );
endmodule
