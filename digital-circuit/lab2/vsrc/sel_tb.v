`timescale 1ns / 1ps
`include "sel.v"
module sel_tb;
    parameter WIDTH = 2;
    wire[WIDTH - 1: 0] x0 = 2'b11;
    wire[WIDTH - 1: 0] x1 = 2'b00;
    wire[WIDTH - 1: 0] x2 = 2'b11;
    wire[WIDTH - 1: 0] x3 = 2'b00;
    reg [WIDTH - 1: 0] y;
    wire[WIDTH - 1: 0] f;

    sel #(WIDTH) sel_ins (
        x0, 
        x1, 
        x2,
        x3,
        y, 
        f
    );

    initial begin
        y = 0;
        # 10 y = 1;
        # 10 y = 2;
    end
    initial begin
        # 25 y = 3;
        # 200 $finish;
    end
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end
endmodule
