module pipe
(
    input                                   clk,
    input                                   rst,

    input                                   flush,

    input                                   pin_valid,
    output                                  pin_ready,

    output                                  pout_valid,
    input                                   pout_ready
);

/*
in_valid   valid_q   out_ready  |  out_valid(flush)  next_valid_q(flush)  in_ready(flush)
    0         0         0       |      0(0)              0(0)                 1(1)
    0         0         1       |      0(0)              0(0)                 1(1)
    0         1         0       |      1(0)              1(0)                 0(1)
    0         1         1       |      1(0)              0(0)                 1(1)
    1         0         0       |      0(0)              1(1)                 1(1)
    1         0         1       |      0(0)              1(1)                 1(1)
    1         1         0       |      1(0)              1(1)                 0(1)
    1         1         1       |      1(0)              1(1)                 1(1)
*/
    reg                 valid_q;
    wire                valid_d;
    wire                valid_en;

    assign pin_ready = ~valid_q | pout_ready | flush;
    assign valid_d   = pin_valid | (~flush & valid_q & ~pout_ready);
    // assign valid_en = (pin_valid & ~valid_q) | (~pin_valid & valid_q & pout_ready); // <=> pin_ready
    assign valid_en = pin_ready;

    always @(posedge clk) begin
        if (rst == `ysyx_23060251_rst_enable)
            valid_q <= 0;
        else if (valid_en)
            valid_q <= pin_valid;
    end

    assign pout_valid = valid_q & ~flush;
endmodule
