module top #(parameter int WIDTH = 8) (
    input  wire clk,
    output wire[3: 0] bcd0,
    output wire[3: 0] bcd1,
    output wire[6: 0] hex0_o,
    output wire[6: 0] hex1_o
);

    shift #(WIDTH) shifter_ins(
        .clk_i(clk),
        .data_i(8'b0000_0001),
        .data_o({bcd1, bcd0})
    );
    seg seg_ins0(
       .bcd_i(bcd0),
       .hex_o(hex0_o)
    );
    seg seg_ins1(
       .bcd_i(bcd1),
       .hex_o(hex1_o)
    );
endmodule
