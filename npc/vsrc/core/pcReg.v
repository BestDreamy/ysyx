module pcReg (
    input wire clk_i,
    input wire rst_i,
    output reg[`ysyx_23060251_pc_bus] pc_o
);
    always @(posedge clk_i) begin
        if (rst_i) pc_o <= 0;
        else pc_o <= pc_o + 4;
    end
endmodule
