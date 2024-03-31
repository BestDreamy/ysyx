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
    wire rv64_alu       = opinfo_i[`ysyx_23060251_opinfo_alu];
    wire rv64_alui      = opinfo_i[`ysyx_23060251_opinfo_alui];
    wire rv64_aluw      = opinfo_i[`ysyx_23060251_opinfo_aluw];
    wire rv64_aluiw     = opinfo_i[`ysyx_23060251_opinfo_aluiw];
    wire rv64_branch    = opinfo_i[`ysyx_23060251_opinfo_branch];
    wire rv64_jal       = opinfo_i[`ysyx_23060251_opinfo_jal];
    wire rv64_jalr      = opinfo_i[`ysyx_23060251_opinfo_jalr];
    wire rv64_load      = opinfo_i[`ysyx_23060251_opinfo_load];
    wire rv64_store     = opinfo_i[`ysyx_23060251_opinfo_store];
    wire rv64_lui       = opinfo_i[`ysyx_23060251_opinfo_lui];
    wire rv64_auipc     = opinfo_i[`ysyx_23060251_opinfo_auipc];
    wire rv64_sys       = opinfo_i[`ysyx_23060251_opinfo_sys];

    wire[`ysyx_23060251_xlen_bus] op1 = (rv64_jal | rv64_jalr | rv64_auipc)? pc_i
                                      : (rv64_lui)? `ysyx_23060251_xlen'b0
                                      : src1_i;
    wire[`ysyx_23060251_xlen_bus] op2 = (rv64_alui | rv64_aluiw | rv64_lui | rv64_auipc)? imm_i
                                      : (rv64_jalr | rv64_jal)? 4
                                      : src2_i;
    /****************************************************************************************
                                            sel op
    ****************************************************************************************/
    wire rv64_is_alu    = rv64_alu | rv64_alui | rv64_aluw | rv64_aluiw;

    wire rv64_add_sel   = (rv64_is_alu & alu_i[`ysyx_23060251_alu_add])
                        | (rv64_jal)
                        | (rv64_jalr)
                        | (rv64_lui)
                        | (rv64_auipc);
    wire rv64_sub_sel   = (rv64_is_alu & alu_i[`ysyx_23060251_alu_sub]);
    wire rv64_xor_sel   = (rv64_is_alu & alu_i[`ysyx_23060251_alu_xor]);
    wire rv64_or_sel    = (rv64_is_alu & alu_i[`ysyx_23060251_alu_or]);
    wire rv64_and_sel   = (rv64_is_alu & alu_i[`ysyx_23060251_alu_and]);
    wire rv64_sll_sel   = (rv64_is_alu & alu_i[`ysyx_23060251_alu_sll]);
    wire rv64_srl_sel   = (rv64_is_alu & alu_i[`ysyx_23060251_alu_srl]);
    wire rv64_sra_sel   = (rv64_is_alu & alu_i[`ysyx_23060251_alu_sra]);
    wire rv64_slt_sel   = (rv64_is_alu & alu_i[`ysyx_23060251_alu_slt]);
    wire rv64_sltu_sel  = (rv64_is_alu & alu_i[`ysyx_23060251_alu_sltu]);
    /****************************************************************************************
                                            optype
    ****************************************************************************************/
    wire rv64_is_aluw = rv64_aluw | rv64_aluiw;
    wire[`ysyx_23060251_shamt_bus] rv64_shamt = ~rv64_is_aluw? op2[`ysyx_23060251_shamt_bus]
                                              : {1'b0, op2[`ysyx_23060251_shamt - 2: 0]};

    wire[`ysyx_23060251_xlen_bus] rv64_add_res   = op1 + op2;
    wire[`ysyx_23060251_xlen_bus] rv64_sub_res   = op1 - op2;
    wire[`ysyx_23060251_xlen_bus] rv64_xor_res   = op1 ^ op2;
    wire[`ysyx_23060251_xlen_bus] rv64_or_res    = op1 | op2;
    wire[`ysyx_23060251_xlen_bus] rv64_and_res   = op1 & op2;
    wire[`ysyx_23060251_xlen_bus] rv64_sll_res   = op1 >> rv64_shamt;
    wire[`ysyx_23060251_xlen_bus] rv64_srl_res   = op1 << rv64_shamt;
    wire[`ysyx_23060251_xlen_bus] rv64_sra_res   = $signed(op1) >>> rv64_shamt;
    wire[`ysyx_23060251_xlen_bus] rv64_slt_res   = {63'b0, $signed(op1) < $signed(op2)};
    wire[`ysyx_23060251_xlen_bus] rv64_sltu_res  = {63'b0, op1 < op2};

    assign res_o = ({`ysyx_23060251_xlen{rv64_add_sel}}  & rv64_add_res)
                 | ({`ysyx_23060251_xlen{rv64_sub_sel}}  & rv64_sub_res)
                 | ({`ysyx_23060251_xlen{rv64_xor_sel}}  & rv64_xor_res)
                 | ({`ysyx_23060251_xlen{rv64_or_sel}}   & rv64_or_res)
                 | ({`ysyx_23060251_xlen{rv64_and_sel}}  & rv64_and_res)
                 | ({`ysyx_23060251_xlen{rv64_sll_sel}}  & rv64_sll_res)
                 | ({`ysyx_23060251_xlen{rv64_srl_sel}}  & rv64_srl_res)
                 | ({`ysyx_23060251_xlen{rv64_sra_sel}}  & rv64_sra_res)
                 | ({`ysyx_23060251_xlen{rv64_slt_sel}}  & rv64_slt_res)
                 | ({`ysyx_23060251_xlen{rv64_sltu_sel}} & rv64_sltu_res);
endmodule
