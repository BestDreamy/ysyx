module csr (
    input clk_i,
    input rst_i,
    input wire is_ecall_i,
    input wire is_mret_i,
    input wire[`ysyx_23060251_imm_bus] imm_i, // csr
    input wire[`ysyx_23060251_xlen_bus] res_i, // csr
    input wire[`ysyx_23060251_reg_bus] mepc_i, // ecall
    input wire[`ysyx_23060251_reg_bus] mcause_i, // ecall

    output reg[`ysyx_23060251_reg_bus] mstatus_o,
    output reg[`ysyx_23060251_reg_bus] mtvec_o,
    output reg[`ysyx_23060251_reg_bus] mepc_o,
    output reg[`ysyx_23060251_reg_bus] mcause_o
);
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
            mstatus_o[`ysyx_23060251_mstatus_xPIE_bus] <= 'b0001;
            // mstatus_o[`ysyx_23060251_mstatus_xPP_bus]  <= 'b11000;
        end else if (imm_o == `ysyx_23060251_mstatus) begin
            mstatus_o <= res_i;
        end
    end

    always @(posedge clk_i) begin
        if (is_ecall_i) begin
            mcause_o <= mcause_i;
        end else if (imm_o == `ysyx_23060251_mcause) begin
            mcause_o <= res_i;
        end
    end

    always @(posedge clk_i) begin
        if (is_ecall_i) begin
            mepc_o <= mepc_i;
        end else if (imm_o == `ysyx_23060251_mepc) begin
            mepc_o <= res_i;
        end
    end

    always @(posedge clk_i) begin
        if (imm_o == `ysyx_23060251_mtvec) begin
            mtvec_o <= res_i;
        end
    end

endmodule
