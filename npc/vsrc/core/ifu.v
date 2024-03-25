`include "defines.v"
`include "pc.v"
`include "rom.v"

module ifu (
    input wire clk_i,
    input wire rst_i,
    input wire[ysyx_23060251_pc_bus] pc_i,

    output wire[ysyx_23060251_inst_bus] inst_o
);

    rom ysyx_23060251_rom (
        .pc_i(pc_i),
        .inst_o(inst_o)
    );

    pc ysyx_23060251_pc (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pc_o(pc_i)
    );

endmodule
