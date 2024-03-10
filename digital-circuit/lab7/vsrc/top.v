module top (
    input  wire clk_i,
    input  wire clrn_i,
    input  wire ps2_clk_i,    // unit of time when transport a bit
    input  wire ps2_data_i,   // each key will transport a bit one by one
    output wire[6: 0] hex0_o,
    output wire[6: 0] hex1_o,
    output wire[6: 0] hex2_o,
    output wire[6: 0] hex3_o,
    output wire[6: 0] hex4_o,
    output wire[6: 0] hex5_o
);
    wire ready, overflow;
    wire[7: 0] data_o;  // transport the real byte by keyboard
    wire[7: 0] ps2_count;

    ps2_keyboard ps2_keyboard_ins (
        .clk(clk_i),
        .clrn(clrn_i),
        .ps2_clk(ps2_clk_i),
        .ps2_data(ps2_data_i),
        .nextdata_n(1'b0),
        .data(data_o),
        .ready(ready),
        .overflow(overflow),
        .ps2_count(ps2_count)
    );
    seg seg_ins0 (
       .bcd_i(data_o[3: 0]),
       .hex_o(hex0_o)
    );
    seg seg_ins1 (
       .bcd_i(data_o[7: 4]),
       .hex_o(hex1_o)
    );

    wire[7: 0] ascii_o;
    ps2_keyboard_lut ps2_keyboard_lut_ins (
        .keyboard_i(data_o),
        .ascii_o(ascii_o)
    );
    seg seg_ins2 (
        .bcd_i(ascii_o[3: 0]),
        .hex_o(hex2_o)
    );
    seg seg_ins3 (
        .bcd_i(ascii_o[7: 4]),
        .hex_o(hex3_o)
    );

    seg seg_ins4 (
        .bcd_i(ps2_count[3: 0]),
        .hex_o(hex4_o)
    );
    seg seg_ins5 (
        .bcd_i(ps2_count[7: 4]),
        .hex_o(hex5_o)
    );

endmodule
