`define ysyx_23060251_xlen 64

`define ysyx_23060251_pc 64
`define ysyx_23060251_pc_bus `ysyx_23060251_pc - 1: 0
`define ysyx_23060251_reg 64
`define ysyx_23060251_reg_num 32
// 64: 0
`define ysyx_23060251_reg_bus `ysyx_23060251_xlen - 1: 0

`define ysyx_23060251_inst 32
`define ysyx_23060251_inst_bus `ysyx_23060251_inst - 1: 0


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
