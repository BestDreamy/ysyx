module shift #(parameter int WIDTH = 8) (
    input  wire               clk_i,
    input  wire[WIDTH - 1: 0] data_i,
    output  reg[WIDTH - 1: 0] data_o
);
    initial begin
        data_o = data_i;
    end

    parameter int COUNT_CYCLE = 5000000;
    int count = 0;
    wire new_bit = data_o[4] ^ data_o[3] ^ data_o[2] ^ data_o[0];
    always @(posedge clk_i) begin
        if (count < COUNT_CYCLE) count <= count + 1;
        else begin
            count <= 0;
            data_o <= {new_bit, data_o[WIDTH - 1: 1]};
        end
    end

endmodule
