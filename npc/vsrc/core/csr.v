module csr (
    input clk_i,
    input rst_i,
    input wire wenCsr_i,
    input wire is_ecall_i,
    input wire is_mret_i,
    input wire[`ysyx_23060251_imm_bus] imm_i, // csr
    input wire[`ysyx_23060251_reg_bus] src1_i, // csr
    input wire[`ysyx_23060251_reg_bus] mepc_i, // ecall
    input wire[`ysyx_23060251_reg_bus] mcause_i, // ecall

    output wire[`ysyx_23060251_reg_bus] data_o
);

    reg[`ysyx_23060251_reg_bus] mstatus;
    reg[`ysyx_23060251_reg_bus] mtvec;
    reg[`ysyx_23060251_reg_bus] mepc;
    reg[`ysyx_23060251_reg_bus] mcause;

    assign data_o = {`ysyx_23060251_xlen{imm_i == `ysyx_23060251_mstatus}}              & mstatus
                  | {`ysyx_23060251_xlen{imm_i == `ysyx_23060251_mtvec | is_ecall_i}}   & mtvec
                  | {`ysyx_23060251_xlen{imm_i == `ysyx_23060251_mepc  | is_mret_i}}    & mepc
                  | {`ysyx_23060251_xlen{imm_i == `ysyx_23060251_mcause}}               & mcause
                  ;

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable) begin
            mstatus[`ysyx_23060251_mstatus_xIE_bus]  <= 'b0000;
            mstatus[`ysyx_23060251_mstatus_xPIE_bus] <= 'b0000;
            mstatus[`ysyx_23060251_mstatus_xPP_bus]  <= 'b11000;
        end else if (is_ecall_i) begin
            mstatus[`ysyx_23060251_mstatus_xIE_bus]  <= 'b0000;
            mstatus[`ysyx_23060251_mstatus_xPIE_bus] <= mstatus[`ysyx_23060251_mstatus_xIE_bus];
            // mstatus_o[`ysyx_23060251_mstatus_xPP_bus]  <= 'b11000;
        end else if (is_mret_i) begin
            mstatus[`ysyx_23060251_mstatus_xIE_bus]  <= mstatus[`ysyx_23060251_mstatus_xPIE_bus];
            mstatus[`ysyx_23060251_mstatus_xPIE_bus] <= 'b0000;
            // mstatus_o[`ysyx_23060251_mstatus_xPP_bus]  <= 'b11000;
        end else if (imm_i == `ysyx_23060251_mstatus & wenCsr_i) begin
            mstatus <= src1_i;
        end
    end

    always @(posedge clk_i) begin
        if (is_ecall_i) begin
            mcause <= mcause_i;
        end else if (imm_i == `ysyx_23060251_mcause & wenCsr_i) begin
            mcause <= src1_i;
        end
    end

    always @(posedge clk_i) begin
        if (is_ecall_i) begin
            mepc <= mepc_i;
        end else if (imm_i == `ysyx_23060251_mepc & wenCsr_i) begin
            mepc <= src1_i;
        end
    end

    always @(posedge clk_i) begin
        if (imm_i == `ysyx_23060251_mtvec & wenCsr_i) begin
            mtvec <= src1_i;
        end
    end

endmodule
