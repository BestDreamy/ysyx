module bjp (
    input  wire                         is_branch_i,
    input  wire                         is_jal_i,
    input  wire                         is_jalr_i,
    input  wire[`ysyx_23060251_pc_bus]  pc_i,
    input  wire[`ysyx_23060251_reg_bus] src1_i,
    input  wire[`ysyx_23060251_imm_bus] imm_i,
    input  wire                         cnd_i,

    output wire[`ysyx_23060251_pc_bus]  npc_o
);

    // branch  ( pc + imm)
    // jal     ( pc + imm)
    // jalr    (rs1 + imm)
    assign npc_o = ((is_branch_i & cnd_i) | is_jal_i)? pc_i + imm_i
                 : is_jalr_i? src1_i + imm_i
                 : pc_i + 4;
    // ({`ysyx_23060251_pc{(is_branch_i & ~cnd_i)}} & (pc_i + 4))
    //              | ({`ysyx_23060251_pc{(is_branch_i & cnd_i) | is_jal_i}} & (pc_i + imm_i))
    //              | ({`ysyx_23060251_pc{is_jalr_i}} & (src1_i + imm_i));

endmodule
