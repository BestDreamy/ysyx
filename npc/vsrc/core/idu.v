module idu (
    input wire[`ysyx_23060251_inst_bus] inst_i,

    output wire[`ysyx_23060251_opinfo_bus] opinfo_o,
    output wire[`ysyx_23060251_alu_bus] alu_o,
    output wire[`ysyx_23060251_branch_bus] branch_o,
    output wire[`ysyx_23060251_load_bus] load_o,
    output wire[`ysyx_23060251_store_bus] store_o,
    output wire[`ysyx_23060251_sys_bus] sys_o,

    output wire                         wenReg_o,
    output wire[`ysyx_23060251_rs_bus]  rd_o,
    output wire[`ysyx_23060251_rs_bus]  rs1_o,
    output wire[`ysyx_23060251_reg_bus] src1_o,
    output wire[`ysyx_23060251_rs_bus]  rs2_o,
    output wire[`ysyx_23060251_reg_bus] src2_o,
    output wire[`ysyx_23060251_imm_bus] imm_o,

    output wire is_load_signed_o,
    output wire wenMem_o,
    output wire renMem_o,
    output wire[`ysyx_23060251_mask_bus] mask_o
);
    wire[`ysyx_23060251_opcode_bus] opcode = inst_i[6: 0];
    assign                           rs1_o = inst_i[19: 15];
    assign                           rs2_o = inst_i[24: 20];
    assign                           rd_o  = inst_i[11: 7];
    wire[`ysyx_23060251_func3_bus]   func3 = inst_i[14: 12];
    wire[`ysyx_23060251_func7_bus]   func7 = inst_i[31: 25];

    /****************************************************************************************
                                            opcode
    ****************************************************************************************/
    wire rv64_alu       = (opcode == 7'b01_100_11);
    wire rv64_alui      = (opcode == 7'b00_100_11);
    wire rv64_aluw      = (opcode == 7'b01_110_11);
    wire rv64_aluiw     = (opcode == 7'b00_110_11);
    wire rv64_branch    = (opcode == 7'b11_000_11);
    wire rv64_jal       = (opcode == 7'b11_011_11);
    wire rv64_jalr      = (opcode == 7'b11_001_11);
    wire rv64_load      = (opcode == 7'b00_000_11);
    wire rv64_store     = (opcode == 7'b01_000_11);
    wire rv64_lui       = (opcode == 7'b01_101_11);
    wire rv64_auipc     = (opcode == 7'b00_101_11);
    wire rv64_sys       = (opcode == 7'b11_100_11);

    assign wenReg_o = ~(opinfo_o[`ysyx_23060251_opinfo_branch] | opinfo_o[`ysyx_23060251_opinfo_store]
                    |   opinfo_o[`ysyx_23060251_opinfo_sys]);
    /****************************************************************************************
                                            optype
    ****************************************************************************************/
    // 1. reg op reg
    wire rv64_add    = rv64_alu   & (func3 == 3'b000) & (func7 == 7'b00_000_00);
    wire rv64_addw   = rv64_aluw  & (func3 == 3'b000) & (func7 == 7'b00_000_00);
    wire rv64_sub    = rv64_alu   & (func3 == 3'b000) & (func7 == 7'b01_000_00);
    wire rv64_subw   = rv64_aluw  & (func3 == 3'b000) & (func7 == 7'b01_000_00);
    wire rv64_xor    = rv64_alu   & (func3 == 3'b100) & (func7 == 7'b00_000_00);
    wire rv64_or     = rv64_alu   & (func3 == 3'b110) & (func7 == 7'b00_000_00);
    wire rv64_and    = rv64_alu   & (func3 == 3'b111) & (func7 == 7'b00_000_00);
    wire rv64_sll    = rv64_alu   & (func3 == 3'b001) & (func7 == 7'b00_000_00);
    wire rv64_sllw   = rv64_aluw  & (func3 == 3'b001) & (func7 == 7'b00_000_00);
    wire rv64_srl    = rv64_alu   & (func3 == 3'b101) & (func7 == 7'b00_000_00);
    wire rv64_srlw   = rv64_aluw  & (func3 == 3'b101) & (func7 == 7'b00_000_00);
    wire rv64_sra    = rv64_alu   & (func3 == 3'b101) & (func7 == 7'b01_000_00);
    wire rv64_sraw   = rv64_aluw  & (func3 == 3'b101) & (func7 == 7'b01_000_00);
    wire rv64_slt    = rv64_alu   & (func3 == 3'b010) & (func7 == 7'b00_000_00);
    wire rv64_sltu   = rv64_alu   & (func3 == 3'b011) & (func7 == 7'b00_000_00);
    wire rv64_mul    = rv64_alu   & (func3 == 3'b000) & (func7 == 7'b00_000_01);
    wire rv64_mulh   = rv64_alu   & (func3 == 3'b001) & (func7 == 7'b00_000_01);
    wire rv64_mulhsu = rv64_alu   & (func3 == 3'b010) & (func7 == 7'b00_000_01);
    wire rv64_mulhu  = rv64_alu   & (func3 == 3'b011) & (func7 == 7'b00_000_01);
    wire rv64_div    = rv64_alu   & (func3 == 3'b100) & (func7 == 7'b00_000_01);
    wire rv64_divu   = rv64_alu   & (func3 == 3'b101) & (func7 == 7'b00_000_01);
    wire rv64_rem    = rv64_alu   & (func3 == 3'b110) & (func7 == 7'b00_000_01);
    wire rv64_remu   = rv64_alu   & (func3 == 3'b111) & (func7 == 7'b00_000_01);

    // 2. reg op imm
    wire rv64_addi  = rv64_alui   & (func3 == 3'b000);
    wire rv64_addiw = rv64_aluiw  & (func3 == 3'b000);
    //   rv64_subi  = rv64_addi
    //   rv64_subiw = rv64_addiw
    wire rv64_xori  = rv64_alui   & (func3 == 3'b100);
    wire rv64_ori   = rv64_alui   & (func3 == 3'b110);
    wire rv64_andi  = rv64_alui   & (func3 == 3'b111);
    wire rv64_slli  = rv64_alui   & (func3 == 3'b001) & (func7 == 7'b00_000_00);
    wire rv64_slliw = rv64_aluiw  & (func3 == 3'b001) & (func7 == 7'b00_000_00);
    wire rv64_srli  = rv64_alui   & (func3 == 3'b101) & (func7 == 7'b00_000_00);
    wire rv64_srliw = rv64_aluiw  & (func3 == 3'b101) & (func7 == 7'b00_000_00);
    wire rv64_srai  = rv64_alui   & (func3 == 3'b101) & (func7 == 7'b01_000_00);
    wire rv64_sraiw = rv64_aluiw  & (func3 == 3'b101) & (func7 == 7'b01_000_00);
    wire rv64_slti  = rv64_alui   & (func3 == 3'b010);
    wire rv64_sltui = rv64_alui   & (func3 == 3'b011);

    // 3. branch
    wire rv64_beq  = rv64_branch & (func3 == 3'b000);
    wire rv64_bne  = rv64_branch & (func3 == 3'b001);
    wire rv64_blt  = rv64_branch & (func3 == 3'b100);
    wire rv64_bge  = rv64_branch & (func3 == 3'b101);
    wire rv64_bltu = rv64_branch & (func3 == 3'b110);
    wire rv64_bgeu = rv64_branch & (func3 == 3'b111);

    // 4. load
    wire rv64_lb  = rv64_load & (func3 == 3'b000);
    wire rv64_lh  = rv64_load & (func3 == 3'b001);
    wire rv64_lw  = rv64_load & (func3 == 3'b010);
    wire rv64_ld  = rv64_load & (func3 == 3'b011);
    wire rv64_lbu = rv64_load & (func3 == 3'b100);
    wire rv64_lhu = rv64_load & (func3 == 3'b101);
    wire rv64_lwu = rv64_load & (func3 == 3'b110);

    // 5. store
    wire rv64_sb = rv64_store & (func3 == 3'b000);
    wire rv64_sh = rv64_store & (func3 == 3'b001);
    wire rv64_sw = rv64_store & (func3 == 3'b010);
    wire rv64_sd = rv64_store & (func3 == 3'b011);

    // 6. system
    wire rv64_ecall  = rv64_sys & (func3 == 3'b000) & (inst_i[31:20] == 12'b0000_0000_0000);
    wire rv64_ebreak = rv64_sys & (func3 == 3'b000) & (inst_i[31:20] == 12'b0000_0000_0001);
    // wire rv64_mret   = rv64_sys & (func3 == 3'b000) & (inst_i[31:20] == 12'b0011_0000_0010);


    /****************************************************************************************
                                            info
    ****************************************************************************************/
    assign opinfo_o = {
        rv64_sys,         // 11
        rv64_auipc,
        rv64_lui,
        rv64_store,
        rv64_load,
        rv64_jalr,
        rv64_jal,
        rv64_branch,
        rv64_aluiw,
        rv64_aluw,
        rv64_alui,
        rv64_alu          // 0
    };

    assign alu_o = {
        rv64_remu,
        rv64_rem,
        rv64_divu,
        rv64_div,
        rv64_mulhu,
        rv64_mulhsu,
        rv64_mulh,
        rv64_mul,
        rv64_sltu| rv64_sltui,
        rv64_slt | rv64_slti,
        rv64_sra | rv64_sraw | rv64_srai | rv64_sraiw,
        rv64_srl | rv64_srlw | rv64_srli | rv64_srliw,
        rv64_sll | rv64_sllw | rv64_slli | rv64_slliw,
        rv64_and | rv64_andi,
        rv64_or  | rv64_ori,
        rv64_xor | rv64_xori,
        rv64_sub | rv64_subw,
        rv64_add | rv64_addw | rv64_addi | rv64_addiw
    };
    assign branch_o = {
        rv64_bgeu,
        rv64_bltu,
        rv64_bge,
        rv64_blt,
        rv64_bne,
        rv64_beq
    };
    assign load_o = {
        rv64_lwu,
        rv64_lhu,
        rv64_lbu,
        rv64_ld,
        rv64_lw,
        rv64_lh,
        rv64_lb
    };
    assign store_o = {
        rv64_sd,
        rv64_sw,
        rv64_sh,
        rv64_sb
    };
    assign sys_o = {
        rv64_ebreak,
        rv64_ecall
    };


    /****************************************************************************************
                                            imm
    ****************************************************************************************/
    // I, S, B, U, J
    wire[`ysyx_23060251_type - 1: 1] rv64_imm_sel = {
        rv64_jal,    // J-type
        rv64_lui | rv64_auipc, // U-type
        rv64_branch, // B-type
        rv64_store,  // S-type
        rv64_alui | rv64_aluiw | rv64_load | rv64_jalr // I-type
    };

    igu ysyx_23060251_igu (
        .imm_sel_i(rv64_imm_sel),
        .inst_i(inst_i),
        .imm_o(imm_o)
    );

    /****************************************************************************************
                                            mem
    ****************************************************************************************/
    assign is_load_signed_o = ~(rv64_lbu | rv64_lhu | rv64_lwu);
    assign renMem_o = rv64_load;
    assign wenMem_o = rv64_store;
    assign mask_o = ({`ysyx_23060251_mask{rv64_lb | rv64_lbu | rv64_sb}} & `ysyx_23060251_mask_byte)
                  | ({`ysyx_23060251_mask{rv64_lh | rv64_lhu | rv64_sh}} & `ysyx_23060251_mask_half)
                  | ({`ysyx_23060251_mask{rv64_lw | rv64_lwu | rv64_sw}} & `ysyx_23060251_mask_word)
                  | ({`ysyx_23060251_mask{rv64_ld            | rv64_sd}} & `ysyx_23060251_mask_double);
endmodule
