// // execute stage
// module bru (
//     input                           is_branch_i,
//     // input                           is_jal_i,
//     input                           is_jalr_i,
//     input                           is_ecall_i,
//     input                           is_mret_i,
//     input  [`ysyx_23060251_pc_bus]  pc_i,
//     input  [`ysyx_23060251_pc_bus]  pred_pc_i, 
//     input  [`ysyx_23060251_reg_bus] src1_i,
//     input  [`ysyx_23060251_imm_bus] imm_i,
//     input                           cnd_i,
//     input  [`ysyx_23060251_reg_bus] csr_data_i,

//     output [`ysyx_23060251_pc_bus]  npc_o
// );
//     // branch  ( pc + imm)  --> (~cnd) -->  npc=pc+4
//     // jal     ( pc + imm)
//     // jalr    (rs1 + imm)  -->             npc=rs1+imm
//     // ecall, mret          -->             npc=csr_data
//     assign npc_o = (is_branch_i & cnd_i)? pc_i + imm_i
//                 //  : (is_jalr_i)? src1_i + imm_i
//                 //  : (is_ecall_i | is_mret_i)? csr_data_i
//                  : pc_i + 4;

// endmodule
