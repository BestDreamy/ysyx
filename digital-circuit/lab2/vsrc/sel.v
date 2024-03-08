module sel #(parameter WIDTH = 2) (
    input  wire[WIDTH - 1: 0] x0,
    input  wire[WIDTH - 1: 0] x1,
    input  wire[WIDTH - 1: 0] x2,
    input  wire[WIDTH - 1: 0] x3,
    input  wire[WIDTH - 1: 0]  y,
    output wire[WIDTH - 1: 0]  f
);
    assign f = ({WIDTH{y == 2'b00}} & x0) |
               ({WIDTH{y == 2'b01}} & x1) |
               ({WIDTH{y == 2'b10}} & x2) |
               ({WIDTH{y == 2'b11}} & x3);
endmodule
