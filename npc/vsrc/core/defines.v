`define ysyx_23060251_xlen 64
`define ysyx_23060251_xlen_bus `ysyx_23060251_xlen_bus - 1: 0
`define ysyx_23060251_rst_enable  1
`define ysyx_23060251_rst_disable 0

`define ysyx_23060251_pc 64
`define ysyx_23060251_pc_bus `ysyx_23060251_pc - 1: 0
// len(Register)
`define ysyx_23060251_reg `ysyx_23060251_xlen
`define ysyx_23060251_reg_num 32
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
`define ysyx_23060251_mem_bus 7: 0
// ROM
`define ysyx_23060251_rom_num 4096
`define ysyx_23060251_rom_bus `ysyx_23060251_mem_bus
// RAM
`define ysyx_23060251_ram_num 4096
`define ysyx_23060251_ram_bus `ysyx_23060251_mem_bus


`define ysyx_23060251_opcode 7
`define ysyx_23060251_opcode_bus `ysyx_23060251_opcode - 1: 0
`define ysyx_23060251_rs     5
`define ysyx_23060251_rs_bus `ysyx_23060251_rs - 1: 0
`define ysyx_23060251_func3  3
`define ysyx_23060251_func3_bus `ysyx_23060251_func3 - 1: 0
`define ysyx_23060251_func7  7
`define ysyx_23060251_func7_bus `ysyx_23060251_func7 - 1: 0


// 1. alu
// 2. alui
// 3. aluw
// 4. aluiw
// 5. branch
// 6. jal
// 7. jalr
// 8. load
// 9. store
// 10.lui
// 11.auipc
// 12.sys
`define ysyx_23060251_opinfo 12
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
`define ysyx_23060251_alu 10
`define ysyx_23060251_alu_bus `ysyx_23060251_alu - 1: 0

// 1. beq
// 2. bne
// 3. blt
// 4. bge
// 5. bltu
// 6. bgeu
`define ysyx_23060251_branch 6
`define ysyx_23060251_branch_bus `ysyx_23060251_branch - 1: 0

// 1. lb
// 2. lh
// 3. lw
// 4. ld
// 5. lbu
// 6. lhu
// 7. lwu
`define ysyx_23060251_load 7
`define ysyx_23060251_load_bus `ysyx_23060251_load - 1: 0

// 1. sb
// 2. sh
// 3. sw
// 4. sd
`define ysyx_23060251_store 4
`define ysyx_23060251_store_bus `ysyx_23060251_store - 1: 0

// 1. ecall
// 2. ebreak
`define ysyx_23060251_sys 2
`define ysyx_23060251_sys_bus `ysyx_23060251_sys - 1: 0