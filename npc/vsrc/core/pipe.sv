module pipe
// #(
//     parameter DATA_WIDTH    = 32
// )
(
    input                                   clk,
    input                                   rst,

    input                                   pin_valid,
    // input           [DATA_WIDTH-1:0]        pin_data,
    output                                  pin_ready,

    output                                  pout_valid,
    // output          [DATA_WIDTH-1:0]        pout_data,
    input                                   pout_ready
);

    // reg[DATA_WIDTH-1:0] data_q;
    reg                 valid_q;

    assign pin_ready = ~valid_q | pout_ready;

    wire valid_en;
    // wire data_en;
    assign valid_en = (~valid_q & pin_valid) | (valid_q & pout_ready);
    // assign data_en  = pin_ready & pin_valid;

    always @(posedge clk) begin
        if (rst == `ysyx_23060251_rst_enable)
            valid_q <= 0;
        else if (valid_en) 
            valid_q <= pin_valid;
    end

    // always @(posedge clk) begin
    //     if (data_en) begin
    //         data_q <= pin_data;
    //     end
    // end

    assign pout_valid = valid_q;
    // assign pout_data  = {DATA_WIDTH{pout_valid}} & data_q;
endmodule