module ifu (
    input wire clk_i,
    input wire rst_i,
    input wire[`ysyx_23060251_pc_bus] pc_i,
    output reg[`ysyx_23060251_inst_bus] inst_o
);

    // rom ysyx_23060251_rom (
    //     .pc_i(pc_i),
    //     .inst_o(inst_o)
    // );
import "DPI-C" function int fetch(int pc);
    always_comb inst_o = fetch(pc_i);

endmodule
