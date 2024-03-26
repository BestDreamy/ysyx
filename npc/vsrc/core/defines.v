`define ysyx_23060251_xlen 64

`define ysyx_23060251_pc 64
`define ysyx_23060251_pc_bus `ysyx_23060251_pc - 1: 0
`define ysyx_23060251_reg 32
`define ysyx_23060251_reg_num 32
// 64: 0
`define ysyx_23060251_reg_bus `ysyx_23060251_xlen - 1: 0

`define ysyx_23060251_inst 32
`define ysyx_23060251_inst_bus `ysyx_23060251_inst - 1: 0


// Memory for inst and data are byte
`define ysyx_23060251_mem_bus 7: 0
// ROM
`define ysyx_23060251_rom_num 1 << `ysyx_23060251_pc - 1
`define ysyx_23060251_rom_bus `ysyx_23060251_mem_bus
// RAM
`define ysyx_23060251_ram_num 4096
`define ysyx_23060251_ram_bus `ysyx_23060251_mem_bus
