module pipe
(
    input                                   clk,
    input                                   rst,

    input                                   pin_valid,
    output                                  pin_ready,

    output                                  pout_valid,
    input                                   pout_ready
);
    reg                 valid_q;

    assign pin_ready = ~valid_q | pout_ready;

    wire valid_en;

    assign valid_en = (~valid_q & pin_valid) | (valid_q & pout_ready);

    always @(posedge clk) begin
        if (rst == `ysyx_23060251_rst_enable)
            valid_q <= 0;
        else if (valid_en)
            valid_q <= pin_valid;
    end

    assign pout_valid = valid_q;
endmodule
