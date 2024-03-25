`include "defines.v"

module top;
reg clk, rst;
reg[63: 0] pc;
wire[31: 0] inst;

ifu ysyx_ifu(
    clk,
    rst,
    pc,
    inst
);
endmodule
