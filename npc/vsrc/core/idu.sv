module idu (
    input   [`ysyx_23060251_inst_bus]       inst_i,
    input   [`ysyx_23060251_opinfo_bus]     opinfo_i,
    input   [`ysyx_23060251_imm_bus]        imm_i,
    input   [`ysyx_23060251_sys_bus]        sys_info_i,

    // bypass
    input   [`ysyx_23060251_reg_bus]        src1_i,     // from decode
    input   [`ysyx_23060251_reg_bus]        csr_data_i, // from decode
    output                                  byp_en_o,
    output  [`ysyx_23060251_pc_bus]         byp_npc_o,

    input   [`ysyx_23060251_rs_bus]         E_byp_rd_i, // from E-pipe
    input   [`ysyx_23060251_rs_bus]         M_byp_rd_i, // from M-pipe
    // bypass end

    input                                   D_valid_i, // from D-pipe
    output                                  d_ready_o, // to D-pipe

    output                                  d_valid_o, // to E
    input                                   E_ready_i, // from E

    output  [`ysyx_23060251_alu_bus]        alu_info_o,
    output  [`ysyx_23060251_branch_bus]     branch_info_o,
    output  [`ysyx_23060251_load_bus]       load_info_o,
    output  [`ysyx_23060251_store_bus]      store_info_o,

    output                                  wenReg_o,
    output                                  wenCsr_o,
    output  [`ysyx_23060251_rs_bus]         rd_o,
    output  [`ysyx_23060251_rs_bus]         rs1_o,
    output  [`ysyx_23060251_rs_bus]         rs2_o,

    output                                  is_load_signed_o,
    output                                  wenMem_o,
    output                                  renMem_o,
    output  [`ysyx_23060251_mask_bus]       mask_o
);

    assign d_valid_o = D_valid_i;
    
    // stall decode-stage
                        // (rs!=rd) | (rs==0)
    assign d_ready_o = (|(rs1_o ^ E_byp_rd_i) | ~(|rs1_o))
                     & (|(rs2_o ^ E_byp_rd_i) | ~(|rs2_o))
                     & (|(rs1_o ^ M_byp_rd_i) | ~(|rs1_o))
                     & (|(rs2_o ^ M_byp_rd_i) | ~(|rs2_o))
                     & E_ready_i;

    assign                           rs1_o = inst_i[19: 15];
    assign                           rs2_o = inst_i[24: 20];
    assign                           rd_o  = inst_i[11: 7];
    wire[`ysyx_23060251_func3_bus]   func3 = inst_i[14: 12];
    wire[`ysyx_23060251_func7_bus]   func7 = inst_i[31: 25];

    /****************************************************************************************
                                            opcode
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

    // assign wenReg_o = ~(rv32_branch | rv32_store);
    assign wenReg_o     = rv32_alu | rv32_addi | rv32_jal | rv32_jalr | rv32_load | rv32_lui | rv32_auipc | rv32_sys;
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
    wire rv32_ebreak = sys_info_i[`ysyx_23060251_sys_ebreak];
    wire rv32_ecall  = sys_info_i[`ysyx_23060251_sys_ecall];
    wire rv32_mret   = sys_info_i[`ysyx_23060251_sys_mret];
    wire rv32_csrrw  = sys_info_i[`ysyx_23060251_csr_csrrw];
    wire rv32_csrrs  = sys_info_i[`ysyx_23060251_csr_csrrs];

    assign wenCsr_o = rv32_csrrw | rv32_ecall | rv32_mret;
    /****************************************************************************************
                                            info
    ****************************************************************************************/
    // 1. reg op reg
    // 2. reg op imm
    assign alu_info_o = {
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
    assign branch_info_o = {
        rv32_bgeu,
        rv32_bltu,
        rv32_bge,
        rv32_blt,
        rv32_bne,
        rv32_beq
    };
    // 4. load
    assign load_info_o = {
        rv32_lwu,
        rv32_lhu,
        rv32_lbu,
        rv32_ld,
        rv32_lw,
        rv32_lh,
        rv32_lb
    };
    // 5. store
    assign store_info_o = {
        rv32_sd,
        rv32_sw,
        rv32_sh,
        rv32_sb
    };
    // 6. sys

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

    /****************************************************************************************
                                            byp
    ****************************************************************************************/
    assign byp_en_o    = d_valid_o & (rv32_jalr | rv32_ecall | rv32_mret);
    assign byp_npc_o   = rv32_jalr? (src1_i + imm_i): csr_data_i;
    
endmodule
