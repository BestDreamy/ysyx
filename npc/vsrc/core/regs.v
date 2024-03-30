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
    wire[`ysyx_23060251_reg_bus] regs[`ysyx_23060251_reg_num];

    assign src1_o = regs[rs1_i];
    assign src2_o = regs[rs2_i];
endmodule