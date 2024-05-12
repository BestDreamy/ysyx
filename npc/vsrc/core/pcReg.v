module pcReg (
    input wire clk_i,
    input wire rst_i,
    input wire[`ysyx_23060251_pc_bus] npc_i,
    output reg[`ysyx_23060251_pc_bus] pc_o
);
    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable) 
            pc_o <= `ysyx_23060251_pc'h8000_0000;
        else 
            pc_o <= npc_i;
    end
endmodule
