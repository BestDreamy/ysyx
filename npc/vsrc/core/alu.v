module alu (
    input  wire[`ysyx_23060251_opinfo_bus] opinfo_i,
    input  wire[`ysyx_23060251_alu_bus] alu_i,
    input  wire[`ysyx_23060251_branch_bus] branch_info_i,

    input  wire[`ysyx_23060251_pc_bus]  pc_i,
    input  wire[`ysyx_23060251_reg_bus] src1_i,
    input  wire[`ysyx_23060251_reg_bus] src2_i,
    input  wire[`ysyx_23060251_imm_bus] imm_i,

    output wire[`ysyx_23060251_xlen_bus] res_o,
    output wire                          cnd_o
);

    /****************************************************************************************
                                            opcode
                                                -- ref: defines.v::45
    ****************************************************************************************/
    wire rv32_alu       = opinfo_i[`ysyx_23060251_opinfo_alu];
    wire rv32_alui      = opinfo_i[`ysyx_23060251_opinfo_alui];
    wire rv32_aluw      = opinfo_i[`ysyx_23060251_opinfo_aluw];
    wire rv32_aluiw     = opinfo_i[`ysyx_23060251_opinfo_aluiw];
    wire rv32_branch    = opinfo_i[`ysyx_23060251_opinfo_branch];
    wire rv32_jal       = opinfo_i[`ysyx_23060251_opinfo_jal];
    wire rv32_jalr      = opinfo_i[`ysyx_23060251_opinfo_jalr];
    wire rv32_load      = opinfo_i[`ysyx_23060251_opinfo_load];
    wire rv32_store     = opinfo_i[`ysyx_23060251_opinfo_store];
    wire rv32_lui       = opinfo_i[`ysyx_23060251_opinfo_lui];
    wire rv32_auipc     = opinfo_i[`ysyx_23060251_opinfo_auipc];
    wire rv32_sys       = opinfo_i[`ysyx_23060251_opinfo_sys];

    wire[`ysyx_23060251_xlen_bus] op1 = (rv32_jal | rv32_jalr | rv32_auipc)? pc_i
                                      : (rv32_lui)? `ysyx_23060251_xlen'b0
                                      : src1_i;
    wire[`ysyx_23060251_xlen_bus] op2 = (rv32_alui | rv32_aluiw | rv32_lui | rv32_auipc | rv32_load | rv32_store)? imm_i
                                      : (rv32_jalr | rv32_jal)? 4
                                      : src2_i;
    /****************************************************************************************
                                            sel op
    ****************************************************************************************/
    wire rv32_is_alu    = rv32_alu | rv32_alui | rv32_aluw | rv32_aluiw;

    wire rv32_add_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_add])
                         | (rv32_jal)
                         | (rv32_jalr)
                         | (rv32_lui)
                         | (rv32_auipc)
                         | (rv32_load)
                         | (rv32_store);
    wire rv32_sub_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_sub]);
    wire rv32_xor_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_xor]);
    wire rv32_or_sel     = (rv32_is_alu & alu_i[`ysyx_23060251_alu_or]);
    wire rv32_and_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_and]);
    wire rv32_sll_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_sll]);
    wire rv32_srl_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_srl]);
    wire rv32_sra_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_sra]);
    wire rv32_slt_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_slt]);
    wire rv32_sltu_sel   = (rv32_is_alu & alu_i[`ysyx_23060251_alu_sltu]);
    wire rv32_mul_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_mul]);
    wire rv32_mulh_sel   = (rv32_is_alu & alu_i[`ysyx_23060251_alu_mulh]);
    wire rv32_mulhsu_sel = (rv32_is_alu & alu_i[`ysyx_23060251_alu_mulhsu]);
    wire rv32_mulhu_sel  = (rv32_is_alu & alu_i[`ysyx_23060251_alu_mulhu]);
    wire rv32_div_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_div]);
    wire rv32_divu_sel   = (rv32_is_alu & alu_i[`ysyx_23060251_alu_divu]);
    wire rv32_rem_sel    = (rv32_is_alu & alu_i[`ysyx_23060251_alu_rem]);
    wire rv32_remu_sel   = (rv32_is_alu & alu_i[`ysyx_23060251_alu_remu]); 
    /****************************************************************************************
                                            optype
    ****************************************************************************************/
    wire rv32_is_aluw = rv32_aluw | rv32_aluiw;
    wire[`ysyx_23060251_shamt_bus] rv32_shamt = ~rv32_is_aluw? op2[`ysyx_23060251_shamt_bus]
                                              : {1'b0, op2[`ysyx_23060251_shamt - 2: 0]};

    wire[`ysyx_23060251_xlen_bus] rv32_add_res    = op1 + op2;
    wire[`ysyx_23060251_xlen_bus] rv32_sub_res    = op1 - op2;
    wire[`ysyx_23060251_xlen_bus] rv32_xor_res    = op1 ^ op2;
    wire[`ysyx_23060251_xlen_bus] rv32_or_res     = op1 | op2;
    wire[`ysyx_23060251_xlen_bus] rv32_and_res    = op1 & op2;
    wire[`ysyx_23060251_xlen_bus] rv32_sll_res    = op1 << rv32_shamt;
    wire[`ysyx_23060251_xlen_bus] rv32_srl_res    = op1 >> rv32_shamt;
    wire[`ysyx_23060251_xlen_bus] rv32_sra_res    = $signed(op1) >>> rv32_shamt;
    wire[`ysyx_23060251_xlen_bus] rv32_slt_res    = {{ext_bool_res{1'b0}}, $signed(op1) < $signed(op2)};
    wire[`ysyx_23060251_xlen_bus] rv32_sltu_res   = {{ext_bool_res{1'b0}}, op1 < op2};
    wire[`ysyx_23060251_mul_bus]  rv32_mul_res    = ($signed(op1) * $signed(op2));
    // wire[`ysyx_23060251_mul_bus]  rv32_mulh_res   = (op1 * op2);
    wire[`ysyx_23060251_mul_bus]  rv32_mulhsu_res = ($signed(op1) * op2);
    wire[`ysyx_23060251_mul_bus]  rv32_mulhu_res  = (op1 * op2);
    wire[`ysyx_23060251_xlen_bus] rv32_div_res    = ($signed(op1) / $signed(op2));
    wire[`ysyx_23060251_xlen_bus] rv32_divu_res   = (op1 / op2);
    wire[`ysyx_23060251_xlen_bus] rv32_rem_res    = ($signed(op1) % $signed(op2));
    wire[`ysyx_23060251_xlen_bus] rv32_remu_res   = (op1 % op2);

    assign res_o = ({`ysyx_23060251_xlen{rv32_add_sel}}     & rv32_add_res)
                 | ({`ysyx_23060251_xlen{rv32_sub_sel}}     & rv32_sub_res)
                 | ({`ysyx_23060251_xlen{rv32_xor_sel}}     & rv32_xor_res)
                 | ({`ysyx_23060251_xlen{rv32_or_sel}}      & rv32_or_res)
                 | ({`ysyx_23060251_xlen{rv32_and_sel}}     & rv32_and_res)
                 | ({`ysyx_23060251_xlen{rv32_sll_sel}}     & rv32_sll_res)
                 | ({`ysyx_23060251_xlen{rv32_srl_sel}}     & rv32_srl_res)
                 | ({`ysyx_23060251_xlen{rv32_sra_sel}}     & rv32_sra_res)
                 | ({`ysyx_23060251_xlen{rv32_slt_sel}}     & rv32_slt_res)
                 | ({`ysyx_23060251_xlen{rv32_sltu_sel}}    & rv32_sltu_res)
                 | ({`ysyx_23060251_xlen{rv32_mul_sel}}     & rv32_mul_res[`ysyx_23060251_mul_low_bus])
                 | ({`ysyx_23060251_xlen{rv32_mulh_sel}}    & rv32_mul_res[`ysyx_23060251_mul_high_bus])
                 | ({`ysyx_23060251_xlen{rv32_mulhsu_sel}}  & rv32_mulhsu_res[`ysyx_23060251_mul_high_bus])
                 | ({`ysyx_23060251_xlen{rv32_mulhu_sel}}   & rv32_mulhu_res[`ysyx_23060251_mul_high_bus])
                 | ({`ysyx_23060251_xlen{rv32_div_sel}}     & rv32_div_res)
                 | ({`ysyx_23060251_xlen{rv32_divu_sel}}    & rv32_divu_res)
                 | ({`ysyx_23060251_xlen{rv32_rem_sel}}     & rv32_rem_res)
                 | ({`ysyx_23060251_xlen{rv32_remu_sel}}    & rv32_remu_res);

    /****************************************************************************************
                                            branch
    ****************************************************************************************/
    wire beq  = branch_info_i[`ysyx_23060251_branch_beq];
    wire bne  = branch_info_i[`ysyx_23060251_branch_bne];
    wire blt  = branch_info_i[`ysyx_23060251_branch_blt];
    wire bge  = branch_info_i[`ysyx_23060251_branch_bge];
    wire bltu = branch_info_i[`ysyx_23060251_branch_bltu];
    wire bgeu = branch_info_i[`ysyx_23060251_branch_bgeu];

    assign cnd_o = (beq  & (op1 == op2)) |
                   (bne  & (op1 != op2)) |
                   (blt  & ($signed(op1) <  $signed(op2))) |
                   (bge  & ($signed(op1) >= $signed(op2))) |
                   (bltu & (op1  < op2)) |
                   (bgeu & (op1 >= op2));
endmodule
