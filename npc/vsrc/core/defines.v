`define ysyx_23060251_xlen 32
`define ysyx_23060251_xlen_bus `ysyx_23060251_xlen - 1: 0
`define ysyx_23060251_rst_enable  1
`define ysyx_23060251_rst_disable 0

`define ysyx_23060251_pc 32
`define ysyx_23060251_pc_bus `ysyx_23060251_pc - 1: 0
// len(Register)
`define ysyx_23060251_reg `ysyx_23060251_xlen
`define ysyx_23060251_reg_num  32
// 63: 0
`define ysyx_23060251_reg_bus `ysyx_23060251_reg  - 1: 0
`define ysyx_23060251_imm `ysyx_23060251_xlen
`define ysyx_23060251_imm_bus `ysyx_23060251_imm - 1: 0

// len(Instruction)
`define ysyx_23060251_inst 32
`define ysyx_23060251_inst_bus `ysyx_23060251_inst - 1: 0
// R, I, S, B, U, J
`define ysyx_23060251_type 6
`define ysyx_23060251_type_bus `ysyx_23060251_type - 1: 0

// Memory for inst and data are byte
`define ysyx_23060251_byte 8
`define ysyx_23060251_half 16
`define ysyx_23060251_word 32
`define ysyx_23060251_double 64

// RAM (0x0800_0000)
// `define ysyx_23060251_ram 28
// `define ysyx_23060251_ram_bus `ysyx_23060251_ram - 1: 0
// 00 --> byte
// 01 --> half
// 10 --> word
// 11 --> double
`define ysyx_23060251_mask_byte 2'b00
`define ysyx_23060251_mask_half 2'b01
`define ysyx_23060251_mask_word 2'b10
`define ysyx_23060251_mask_double 2'b11
`define ysyx_23060251_mask 2
`define ysyx_23060251_mask_bus `ysyx_23060251_mask - 1: 0


`define ysyx_23060251_opcode 7
`define ysyx_23060251_opcode_bus `ysyx_23060251_opcode - 1: 0
`define ysyx_23060251_rs     5
`define ysyx_23060251_reg_zero 0
`define ysyx_23060251_rs_bus `ysyx_23060251_rs - 1: 0
`define ysyx_23060251_func3  3
`define ysyx_23060251_func3_bus `ysyx_23060251_func3 - 1: 0
`define ysyx_23060251_func7  7
`define ysyx_23060251_func7_bus `ysyx_23060251_func7 - 1: 0
`define ysyx_23060251_shamt 6
`define ysyx_23060251_shamt_bus `ysyx_23060251_shamt - 1: 0

// 1. alu      (reg op reg)
// 2. alui     (reg op imm)
// 3. aluw     (reg op reg)
// 4. aluiw    (reg op reg)
// 5. branch   (reg op reg)
// 6. jal      ( pc  +   4)
// 7. jalr     ( pc  +   4)
// 8. load     (reg  + imm)
// 9. store    (reg  + imm)
// 10.lui      (  0  + imm)
// 11.auipc    ( oc  + imm)
// 12.sys
`define ysyx_23060251_opinfo_alu    0
`define ysyx_23060251_opinfo_alui   1
`define ysyx_23060251_opinfo_aluw   2
`define ysyx_23060251_opinfo_aluiw  3
`define ysyx_23060251_opinfo_branch 4
`define ysyx_23060251_opinfo_jal    5
`define ysyx_23060251_opinfo_jalr   6
`define ysyx_23060251_opinfo_load   7
`define ysyx_23060251_opinfo_store  8
`define ysyx_23060251_opinfo_lui    9
`define ysyx_23060251_opinfo_auipc  10
`define ysyx_23060251_opinfo_sys    11
`define ysyx_23060251_opinfo_csr    12
`define ysyx_23060251_opinfo 13
`define ysyx_23060251_opinfo_bus `ysyx_23060251_opinfo - 1: 0

// 1. add
// 2. sub
// 3. xor
// 4. or
// 5. and
// 6. sll
// 7. srl
// 8. sra
// 9. slt
// 10.sltu
// 11.mul
// 12.div
// 13.rem
`define ysyx_23060251_alu_add     0
`define ysyx_23060251_alu_sub     1
`define ysyx_23060251_alu_xor     2
`define ysyx_23060251_alu_or      3
`define ysyx_23060251_alu_and     4
`define ysyx_23060251_alu_sll     5
`define ysyx_23060251_alu_srl     6
`define ysyx_23060251_alu_sra     7
`define ysyx_23060251_alu_slt     8
`define ysyx_23060251_alu_sltu    9
`define ysyx_23060251_alu_mul    10
`define ysyx_23060251_alu_mulh   11
`define ysyx_23060251_alu_mulhsu 12
`define ysyx_23060251_alu_mulhu  13
`define ysyx_23060251_alu_div    14
`define ysyx_23060251_alu_divu   15
`define ysyx_23060251_alu_rem    16
`define ysyx_23060251_alu_remu   17
`define ysyx_23060251_alu        18
`define ysyx_23060251_alu_bus `ysyx_23060251_alu - 1: 0

parameter ext_bool_res      =      `ysyx_23060251_xlen - 1;
parameter ysyx_23060251_mul =      `ysyx_23060251_xlen << 1;
`define ysyx_23060251_mul_bus       ysyx_23060251_mul - 1: 0
`define ysyx_23060251_mul_low_bus  `ysyx_23060251_xlen - 1: 0
`define ysyx_23060251_mul_high_bus  ysyx_23060251_mul - 1: `ysyx_23060251_xlen

// 1. beq
// 2. bne
// 3. blt
// 4. bge
// 5. bltu
// 6. bgeu
`define ysyx_23060251_branch_beq  0
`define ysyx_23060251_branch_bne  1
`define ysyx_23060251_branch_blt  2
`define ysyx_23060251_branch_bge  3
`define ysyx_23060251_branch_bltu 4
`define ysyx_23060251_branch_bgeu 5
`define ysyx_23060251_branch 6
`define ysyx_23060251_branch_bus `ysyx_23060251_branch - 1: 0

// 1. lb
// 2. lh
// 3. lw
// 4. ld
// 5. lbu
// 6. lhu
// 7. lwu
`define ysyx_23060251_load_lb  0
`define ysyx_23060251_load_lh  1
`define ysyx_23060251_load_lw  2
`define ysyx_23060251_load_ld  3
`define ysyx_23060251_load_lbu 4
`define ysyx_23060251_load_lhu 5
`define ysyx_23060251_load_lwu 6
`define ysyx_23060251_load 7
`define ysyx_23060251_load_bus `ysyx_23060251_load - 1: 0

// 1. sb
// 2. sh
// 3. sw
// 4. sd
`define ysyx_23060251_store_sb 0
`define ysyx_23060251_store_sh 1
`define ysyx_23060251_store_sw 2
`define ysyx_23060251_store_sd 3
`define ysyx_23060251_store 4
`define ysyx_23060251_store_bus `ysyx_23060251_store - 1: 0

// 1. ebreak
// 2. ecall
// 3. mret
`define ysyx_23060251_sys_ebreak 0
`define ysyx_23060251_sys_ecall  1
`define ysyx_23060251_sys_mret   2
`define ysyx_23060251_sys 3
`define ysyx_23060251_sys_bus `ysyx_23060251_sys - 1: 0

`define ysyx_23060251_csr_csrrw 0
`define ysyx_23060251_csr_csrrs 1
`define ysyx_23060251_csr 2
`define ysyx_23060251_csr_bus `ysyx_23060251_csr - 1: 0


// csr info
`define ysyx_23060251_mstatus 'h300
`define ysyx_23060251_mtvec   'h305
`define ysyx_23060251_mepc    'h341
`define ysyx_23060251_mcause  'h342

// mstatus
`define ysyx_23060251_mstatus_xIE_bus 3: 0
`define ysyx_23060251_mstatus_xPIE_bus 7: 4
`define ysyx_23060251_mstatus_xPP_bus 12: 8