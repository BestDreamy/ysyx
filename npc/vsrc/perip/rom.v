module rom (
    // input clk_i,
    input wire[`ysyx_23060251_pc_bus] pc_i,
    output wire[`ysyx_23060251_inst_bus] inst_o
);
    // reg[7: 0] instMem[0: 4095]
    // reg[`ysyx_23060251_rom_bus] instMem[0: `ysyx_23060251_rom_num - 1];
    // assign {instMem[3], instMem[2], instMem[1], instMem[0]} = 32'h0000297; //auipc t0, 0

    // assign inst_o = {instMem[pc_i + 3], instMem[pc_i + 2], instMem[pc_i + 1], instMem[pc_i]};

endmodule
