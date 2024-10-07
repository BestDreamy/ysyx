module bru (
    input  wire                         is_branch_i,
    // input  wire                         is_jal_i,
    input  wire                         is_jalr_i,
    input  wire                         is_ecall_i,
    input  wire                         is_mret_i,
    input  wire[`ysyx_23060251_pc_bus]  pc_i,
    input  wire[`ysyx_23060251_reg_bus] src1_i,
    input  wire[`ysyx_23060251_imm_bus] imm_i,
    input  wire                         cnd_i,
    input  wire[`ysyx_23060251_reg_bus] csr_data_i,

    output wire[`ysyx_23060251_pc_bus]  npc_o
);
    // branch  ( pc + imm)  --> (~cnd) -->  npc=pc+4
    // jal     ( pc + imm)
    // jalr    (rs1 + imm)  -->             npc=rs1+imm
    // ecall, mret          -->             npc=csr_data
    assign npc_o = ((is_branch_i & cnd_i) | is_jal_i)? pc_i + imm_i
                 : (is_jalr_i)? src1_i + imm_i
                 : (is_ecall_i | is_mret_i)? csr_data_i
                 : pc_i + 4;

endmodule
