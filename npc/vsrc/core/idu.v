module idu (
    input wire[`ysyx_23060251_inst_bus] inst_i,

    output wire[`ysyx_23060251_opinfo_bus] opinfo_o,
    output wire[`ysyx_23060251_alu_bus] alu_o,
    output wire[`ysyx_23060251_branch_bus] branch_o,
    output wire[`ysyx_23060251_load_bus] load_o,
    output wire[`ysyx_23060251_store_bus] store_o,
    output wire[`ysyx_23060251_sys_bus] sys_o,

    output wire                         wenReg_o,
    output wire                         wenCsr_o,
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
    wire rv32_alu       = (opcode == 7'b01_100_11);
    wire rv32_alui      = (opcode == 7'b00_100_11);
    wire rv32_aluw      = (opcode == 7'b01_110_11);
    wire rv32_aluiw     = (opcode == 7'b00_110_11);
    wire rv32_branch    = (opcode == 7'b11_000_11);
    wire rv32_jal       = (opcode == 7'b11_011_11);
    wire rv32_jalr      = (opcode == 7'b11_001_11);
    wire rv32_load      = (opcode == 7'b00_000_11);
    wire rv32_store     = (opcode == 7'b01_000_11);
    wire rv32_lui       = (opcode == 7'b01_101_11);
    wire rv32_auipc     = (opcode == 7'b00_101_11);
    wire rv32_sys       = (opcode == 7'b11_100_11);
    wire rv32_csr       = (opcode == 7'b11_100_11);

    assign wenReg_o = ~(opinfo_o[`ysyx_23060251_opinfo_branch] 
                      | opinfo_o[`ysyx_23060251_opinfo_store]
                      | opinfo_o[`ysyx_23060251_opinfo_sys]);
    assign wenCsr_o =  (opinfo_o[`ysyx_23060251_opinfo_sys]
                      | opinfo_o[`ysyx_23060251_opinfo_csr]);
    /****************************************************************************************
                                            optype
    ****************************************************************************************/
    // 1. reg op reg
    wire rv32_add    = rv32_alu   & (func3 == 3'b000) & (func7 == 7'b00_000_00);
    wire rv32_addw   = rv32_aluw  & (func3 == 3'b000) & (func7 == 7'b00_000_00);
    wire rv32_sub    = rv32_alu   & (func3 == 3'b000) & (func7 == 7'b01_000_00);
    wire rv32_subw   = rv32_aluw  & (func3 == 3'b000) & (func7 == 7'b01_000_00);
    wire rv32_xor    = rv32_alu   & (func3 == 3'b100) & (func7 == 7'b00_000_00);
    wire rv32_or     = rv32_alu   & (func3 == 3'b110) & (func7 == 7'b00_000_00);
    wire rv32_and    = rv32_alu   & (func3 == 3'b111) & (func7 == 7'b00_000_00);
    wire rv32_sll    = rv32_alu   & (func3 == 3'b001) & (func7 == 7'b00_000_00);
    wire rv32_sllw   = rv32_aluw  & (func3 == 3'b001) & (func7 == 7'b00_000_00);
    wire rv32_srl    = rv32_alu   & (func3 == 3'b101) & (func7 == 7'b00_000_00);
    wire rv32_srlw   = rv32_aluw  & (func3 == 3'b101) & (func7 == 7'b00_000_00);
    wire rv32_sra    = rv32_alu   & (func3 == 3'b101) & (func7 == 7'b01_000_00);
    wire rv32_sraw   = rv32_aluw  & (func3 == 3'b101) & (func7 == 7'b01_000_00);
    wire rv32_slt    = rv32_alu   & (func3 == 3'b010) & (func7 == 7'b00_000_00);
    wire rv32_sltu   = rv32_alu   & (func3 == 3'b011) & (func7 == 7'b00_000_00);
    wire rv32_mul    = rv32_alu   & (func3 == 3'b000) & (func7 == 7'b00_000_01);
    wire rv32_mulh   = rv32_alu   & (func3 == 3'b001) & (func7 == 7'b00_000_01);
    wire rv32_mulhsu = rv32_alu   & (func3 == 3'b010) & (func7 == 7'b00_000_01);
    wire rv32_mulhu  = rv32_alu   & (func3 == 3'b011) & (func7 == 7'b00_000_01);
    wire rv32_div    = rv32_alu   & (func3 == 3'b100) & (func7 == 7'b00_000_01);
    wire rv32_divu   = rv32_alu   & (func3 == 3'b101) & (func7 == 7'b00_000_01);
    wire rv32_rem    = rv32_alu   & (func3 == 3'b110) & (func7 == 7'b00_000_01);
    wire rv32_remu   = rv32_alu   & (func3 == 3'b111) & (func7 == 7'b00_000_01);

    // 2. reg op imm
    wire rv32_addi  = rv32_alui   & (func3 == 3'b000);
    wire rv32_addiw = rv32_aluiw  & (func3 == 3'b000);
    //   rv32_subi  = rv32_addi
    //   rv32_subiw = rv32_addiw
    wire rv32_xori  = rv32_alui   & (func3 == 3'b100);
    wire rv32_ori   = rv32_alui   & (func3 == 3'b110);
    wire rv32_andi  = rv32_alui   & (func3 == 3'b111);
    wire rv32_slli  = rv32_alui   & (func3 == 3'b001) & (func7 == 7'b00_000_00);
    wire rv32_slliw = rv32_aluiw  & (func3 == 3'b001) & (func7 == 7'b00_000_00);
    wire rv32_srli  = rv32_alui   & (func3 == 3'b101) & (func7 == 7'b00_000_00);
    wire rv32_srliw = rv32_aluiw  & (func3 == 3'b101) & (func7 == 7'b00_000_00);
    wire rv32_srai  = rv32_alui   & (func3 == 3'b101) & (func7 == 7'b01_000_00);
    wire rv32_sraiw = rv32_aluiw  & (func3 == 3'b101) & (func7 == 7'b01_000_00);
    wire rv32_slti  = rv32_alui   & (func3 == 3'b010);
    wire rv32_sltui = rv32_alui   & (func3 == 3'b011);

    // 3. branch
    wire rv32_beq  = rv32_branch & (func3 == 3'b000);
    wire rv32_bne  = rv32_branch & (func3 == 3'b001);
    wire rv32_blt  = rv32_branch & (func3 == 3'b100);
    wire rv32_bge  = rv32_branch & (func3 == 3'b101);
    wire rv32_bltu = rv32_branch & (func3 == 3'b110);
    wire rv32_bgeu = rv32_branch & (func3 == 3'b111);

    // 4. load
    wire rv32_lb  = rv32_load & (func3 == 3'b000);
    wire rv32_lh  = rv32_load & (func3 == 3'b001);
    wire rv32_lw  = rv32_load & (func3 == 3'b010);
    wire rv32_ld  = rv32_load & (func3 == 3'b011);
    wire rv32_lbu = rv32_load & (func3 == 3'b100);
    wire rv32_lhu = rv32_load & (func3 == 3'b101);
    wire rv32_lwu = rv32_load & (func3 == 3'b110);

    // 5. store
    wire rv32_sb = rv32_store & (func3 == 3'b000);
    wire rv32_sh = rv32_store & (func3 == 3'b001);
    wire rv32_sw = rv32_store & (func3 == 3'b010);
    wire rv32_sd = rv32_store & (func3 == 3'b011);

    // 6. system
    wire rv32_ecall  = rv32_sys & (func3 == 3'b000) & (inst_i[31:20] == 12'b0000_0000_0000);
    wire rv32_ebreak = rv32_sys & (func3 == 3'b000) & (inst_i[31:20] == 12'b0000_0000_0001);
    wire rv32_mret   = rv32_sys & (func3 == 3'b000) & (inst_i[31:20] == 12'b0011_0000_0010);

    // 7. csr
    wire rv32_csrrw = rv32_csr & (func3 == 3'b001);
    wire rv32_csrrs = rv32_csr & (func3 == 3'b010);


    /****************************************************************************************
                                            info
    ****************************************************************************************/
    // 1. reg op reg
    assign opinfo_o = {
        rv32_csr,
        rv32_sys,         // 11
        rv32_auipc,
        rv32_lui,
        rv32_store,
        rv32_load,
        rv32_jalr,
        rv32_jal,
        rv32_branch,
        rv32_aluiw,
        rv32_aluw,
        rv32_alui,
        rv32_alu          // 0
    };
    // 2. reg op imm
    assign alu_o = {
        rv32_remu,
        rv32_rem,
        rv32_divu,
        rv32_div,
        rv32_mulhu,
        rv32_mulhsu,
        rv32_mulh,
        rv32_mul,
        rv32_sltu| rv32_sltui,
        rv32_slt | rv32_slti,
        rv32_sra | rv32_sraw | rv32_srai | rv32_sraiw,
        rv32_srl | rv32_srlw | rv32_srli | rv32_srliw,
        rv32_sll | rv32_sllw | rv32_slli | rv32_slliw,
        rv32_and | rv32_andi,
        rv32_or  | rv32_ori,
        rv32_xor | rv32_xori,
        rv32_sub | rv32_subw,
        rv32_add | rv32_addw | rv32_addi | rv32_addiw
    };
    // 3. branch
    assign branch_o = {
        rv32_bgeu,
        rv32_bltu,
        rv32_bge,
        rv32_blt,
        rv32_bne,
        rv32_beq
    };
    // 4. load
    assign load_o = {
        rv32_lwu,
        rv32_lhu,
        rv32_lbu,
        rv32_ld,
        rv32_lw,
        rv32_lh,
        rv32_lb
    };
    // 5. store
    assign store_o = {
        rv32_sd,
        rv32_sw,
        rv32_sh,
        rv32_sb
    };
    // 6. sys
    assign sys_o = {
        rv32_mret,
        rv32_ecall,
        rv32_ebreak
    };
    // 7.csr
    assign csr_o = {
        rv32_csrrs,
        rv32_csrrw
    }


    /****************************************************************************************
                                            imm
    ****************************************************************************************/
    // I, S, B, U, J
    wire[`ysyx_23060251_type - 1: 1] rv32_imm_sel = {
        rv32_jal,    // J-type
        rv32_lui | rv32_auipc, // U-type
        rv32_branch, // B-type
        rv32_store,  // S-type
        rv32_alui | rv32_aluiw | rv32_load | rv32_jalr | rv32_csr // I-type (omit a series of sys instruction)
    };

    igu ysyx_23060251_igu (
        .imm_sel_i(rv32_imm_sel),
        .inst_i(inst_i),
        .imm_o(imm_o)
    );

    /****************************************************************************************
                                            mem
    ****************************************************************************************/
    assign is_load_signed_o = rv32_lb | rv32_lh | rv32_lw | rv32_ld;
    assign renMem_o = rv32_load;
    assign wenMem_o = rv32_store;
    assign mask_o = ({`ysyx_23060251_mask{rv32_lb | rv32_lbu | rv32_sb}} & `ysyx_23060251_mask_byte)
                  | ({`ysyx_23060251_mask{rv32_lh | rv32_lhu | rv32_sh}} & `ysyx_23060251_mask_half)
                  | ({`ysyx_23060251_mask{rv32_lw | rv32_lwu | rv32_sw}} & `ysyx_23060251_mask_word)
                  | ({`ysyx_23060251_mask{rv32_ld            | rv32_sd}} & `ysyx_23060251_mask_double);
endmodule
