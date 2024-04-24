module rom (
    input wire rst_i,
    input wire[`ysyx_23060251_pc_bus] pc_i,
    output reg[`ysyx_23060251_inst_bus] inst_o
);
    import "DPI-C" function int fetch(int pc, bit rst_i);
    always_comb inst_o = fetch(pc_i, rst_i);
endmodule
