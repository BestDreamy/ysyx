module alu (
    input  wire[`ysyx_23060251_opinfo_bus] opinfo_i,
    input  wire[`ysyx_23060251_alu_bus] alu_i,
    // input  wire[`ysyx_23060251_branch_bus] branch_i,

    input  wire[`ysyx_23060251_pc_bus]  pc_i,
    input  wire[`ysyx_23060251_reg_bus] src1_i,
    input  wire[`ysyx_23060251_reg_bus] src2_i,
    input  wire[`ysyx_23060251_imm_bus] imm_i,

    output wire[`ysyx_23060251_xlen_bus] res_o
);

// 1. reg op reg
// 2. reg op imm
// 3. pc + 4 (jal, jalr)
// 4. 0 + imm (lui)
// 5. pc + imm (auipc)

    /****************************************************************************************
                                            opcode
    ****************************************************************************************/
    wire rv64_alu       = opinfo_i[0];
    wire rv64_alui      = opinfo_i[1];
    wire rv64_aluw      = opinfo_i[2];
    wire rv64_aluiw     = opinfo_i[3];
    wire rv64_branch    = opinfo_i[4];
    wire rv64_jal       = opinfo_i[5];
    wire rv64_jalr      = opinfo_i[6];
    wire rv64_load      = opinfo_i[7];
    wire rv64_store     = opinfo_i[8];
    wire rv64_lui       = opinfo_i[9];
    wire rv64_auipc     = opinfo_i[10];
    wire rv64_sys       = opinfo_i[11];

    wire[`ysyx_23060251_xlen_bus] op1 = 

    /****************************************************************************************
                                            optype
    ****************************************************************************************/
    
endmodule
