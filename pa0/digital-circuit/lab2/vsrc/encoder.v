module encoder (
    input  wire[7: 0] x_i,
    input  wire       en_i,
    output reg [2: 0] y_o
);
    integer i = 0;

    always@(*) begin
        if (en_i) begin
            y_o = 0;
            for(i = 0; i < 8; i = i + 1) begin
                if (x_i[i] == 1'b1) y_o = i[2: 0];
            end
        end
        else y_o = 0;
    end
endmodule
