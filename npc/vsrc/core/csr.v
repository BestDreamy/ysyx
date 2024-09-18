module csr (
    input                              wenCsr_i,
    input                              is_ecall_i,
    input                              is_mret_i,
    input     [`ysyx_23060251_imm_bus] imm_i,     // csr
    input     [`ysyx_23060251_reg_bus] src1_i,    // csr
    input     [`ysyx_23060251_reg_bus] mepc_i,    // ecall
    input     [`ysyx_23060251_reg_bus] mcause_i,  // ecall

    output reg[`ysyx_23060251_reg_bus] mstatus_o,
    output reg[`ysyx_23060251_reg_bus] mtvec_o,
    output reg[`ysyx_23060251_reg_bus] mepc_o,
    output reg[`ysyx_23060251_reg_bus] mcause_o,
    output    [`ysyx_23060251_reg_bus] data_o,

    input                              clk_i,
    input                              rst_i
);


    // import "DPI-C" function void set_csr(
    //     // input: sv --> c
    //     input bit[`ysyx_23060251_reg_bus] mstatus,
    //     input bit[`ysyx_23060251_reg_bus] mtvec,
    //     input bit[`ysyx_23060251_reg_bus] mepc,
    //     input bit[`ysyx_23060251_reg_bus] mcause
    // );
    // initial set_csr(mstatus, mtvec, mepc, mcause);

    assign data_o = {`ysyx_23060251_xlen{imm_i == `ysyx_23060251_mstatus}}              & mstatus_o
                  | {`ysyx_23060251_xlen{imm_i == `ysyx_23060251_mtvec | is_ecall_i}}   & mtvec_o
                  | {`ysyx_23060251_xlen{imm_i == `ysyx_23060251_mepc  | is_mret_i}}    & mepc_o
                  | {`ysyx_23060251_xlen{imm_i == `ysyx_23060251_mcause}}               & mcause_o
                  ;

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable) begin
            mstatus_o[`ysyx_23060251_mstatus_xIE_bus]  <= 'b0000;
            mstatus_o[`ysyx_23060251_mstatus_xPIE_bus] <= 'b0000;
            mstatus_o[`ysyx_23060251_mstatus_xPP_bus]  <= 'b11000;
        end else if (is_ecall_i) begin
            mstatus_o[`ysyx_23060251_mstatus_xIE_bus]  <= 'b0000;
            mstatus_o[`ysyx_23060251_mstatus_xPIE_bus] <= mstatus_o[`ysyx_23060251_mstatus_xIE_bus];
            // mstatus_o[`ysyx_23060251_mstatus_xPP_bus]  <= 'b11000;
        end else if (is_mret_i) begin
            mstatus_o[`ysyx_23060251_mstatus_xIE_bus]  <= mstatus_o[`ysyx_23060251_mstatus_xPIE_bus];
            mstatus_o[`ysyx_23060251_mstatus_xPIE_bus] <= 'b0000;
            // mstatus_o[`ysyx_23060251_mstatus_xPP_bus]  <= 'b11000;
        end else if (imm_i == `ysyx_23060251_mstatus & wenCsr_i) begin
            mstatus_o <= src1_i;
        end
    end

    always @(posedge clk_i) begin
        if (is_ecall_i) begin
            mcause_o <= mcause_i;
        end else if (imm_i == `ysyx_23060251_mcause & wenCsr_i) begin
            mcause_o <= src1_i;
        end
    end

    always @(posedge clk_i) begin
        if (is_ecall_i) begin
            mepc_o <= mepc_i;
        end else if (imm_i == `ysyx_23060251_mepc & wenCsr_i) begin
            mepc_o <= src1_i;
        end
    end

    always @(posedge clk_i) begin
        if (imm_i == `ysyx_23060251_mtvec & wenCsr_i) begin
            mtvec_o <= src1_i;
        end
    end

endmodule
