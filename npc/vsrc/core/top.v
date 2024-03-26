`include "defines"
module top (
    input clk,
    input rst
);
reg[63: 0] pc;
wire[31: 0] inst;

    pcReg ysyx_23060251_pcReg (
        .clk_i(clk),
        .rst_i(rst),
        .pc_o(pc)
    );

ifu ysyx_ifu(
    clk,
    rst,
    pc,
    inst
);
endmodule
