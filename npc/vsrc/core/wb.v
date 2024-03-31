/*
module wb (
    input  wire                            clk_i,
    input  wire                            rst_i,
    input  wire[`ysyx_23060251_opinfo_bus] opinfo_i,
    input  wire[`ysyx_23060251_rs_bus]     dst_i,
    input  wire[`ysyx_23060251_xlen_bus]   res_i

);
    wire wen = (opinfo_i[`ysyx_23060251_opinfo_branch] | opinfo_i[`ysyx_23060251_opinfo_store]
               |opinfo_i[`ysyx_23060251_opinfo_sys]);

// verilator lint_off PINMISSING
    regs ysyx_23060251_regs (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .wen_i(wen),
        .rd_i(dst_i),
        .wdata_i(res_i)
    );
// verilator lint_on  PINMISSING
endmodule
*/
