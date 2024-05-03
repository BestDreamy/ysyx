module regs (
    input  wire clk_i,
    input  wire rst_i,

    input  wire wen_i,
    input  wire[`ysyx_23060251_rs_bus]  rd_i,
    input  wire[`ysyx_23060251_reg_bus] wdata_i,

    input  wire[`ysyx_23060251_rs_bus]  rs1_i,
    input  wire[`ysyx_23060251_rs_bus]  rs2_i,
    output wire[`ysyx_23060251_reg_bus] src1_o,
    output wire[`ysyx_23060251_reg_bus] src2_o
);
    reg[`ysyx_23060251_reg_bus] gpr[`ysyx_23060251_reg_num];
    import "DPI-C" function void set_gpr_ptr(input bit[`ysyx_23060251_reg_bus] gpr[]);
    initial begin
        // gpr[2] = 32'h80000000;
        set_gpr_ptr(gpr);
    end

    assign src1_o = gpr[rs1_i];
    assign src2_o = gpr[rs2_i];

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_disable && wen_i) begin
            gpr[rd_i] <= wdata_i;
        end
    end
endmodule
