module regs (
    input                               wen_i,
    input  [`ysyx_23060251_rs_bus]      rd_i,
    input  [`ysyx_23060251_reg_bus]     e_wdata_i,
    input                               is_load_i,
    input  [`ysyx_23060251_xlen_bus]    m_wdata_i,

    input  [`ysyx_23060251_rs_bus]      rs1_i,
    input  [`ysyx_23060251_rs_bus]      rs2_i,
    output [`ysyx_23060251_reg_bus]     src1_o,
    output [`ysyx_23060251_reg_bus]     src2_o,

    input                               clk_i,
    input                               rst_i
);
    reg[`ysyx_23060251_reg_bus] gpr[`ysyx_23060251_reg_num];
    import "DPI-C" function void set_gpr_ptr(
        // input: sv --> c
        input bit[`ysyx_23060251_reg_bus] gpr[]
    );
    initial set_gpr_ptr(gpr);

    assign src1_o = gpr[rs1_i];
    assign src2_o = gpr[rs2_i];

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_disable && wen_i && (rd_i != `ysyx_23060251_reg_zero)) begin
            if (is_load_i) gpr[rd_i] <= m_wdata_i;
            else gpr[rd_i] <= e_wdata_i;
        end
    end
endmodule
