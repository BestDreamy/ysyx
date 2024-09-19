module pcu (
    input                               clk_i,
    input                               rst_i,
    input                               wb_en,
    input     [`ysyx_23060251_pc_bus]   npc_i,
    output reg[`ysyx_23060251_pc_bus]   pc_o
);
    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable)
            pc_o <= `ysyx_23060251_pc'h8000_0000;
        else if(wb_en)
            pc_o <= npc_i;
    end
endmodule
