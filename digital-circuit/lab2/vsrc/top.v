module top (
    input  wire[7: 0] x_i,
    input  wire       en_i,
    output wire[2: 0] y_o,
    output wire[6: 0] hex_o
);

   encoder encoder_ins (
       .x_i(x_i),
       .en_i(en_i),
       .y_o(y_o)
   );

   seg seg_ins (
       .bcd_i({1'b0, y_o}), // {0, y_o}
       .hex_o(hex_o)
   );

endmodule
