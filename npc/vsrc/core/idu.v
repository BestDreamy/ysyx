module idu (
    input wire[`ysyx_23060251_inst_bus] inst_i,

    output wire[`ysyx_23060251_xlen] src1_o,
    output wire[`ysyx_23060251_xlen] src2_o,
    output wire[`ysyx_23060251_xlen] imm_o
);
    wire[`ysyx_23060251_opcode_bus] opcode = inst_i[6: 0];
    wire[`ysyx_23060251_rs_bus] rs1 = inst_i[19: 15];
    wire[`ysyx_23060251_rs_bus] rs2 = inst_i[24: 20];
    wire[`ysyx_23060251_rs_bus] rd  = inst_i[11: 7];
    wire[`ysyx_23060251_func3_bus] func3 = inst_i[14: 12];
    wire[`ysyx_23060251_func7_bus] func7 = inst_i[31: 25];

    
endmodule