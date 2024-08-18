module csr (
    input wire[`ysyx_23060251_imm_bus] imm_i,
    input wire[`ysyx_23060251_xlen_bus] res_i,
    input wire wen_i,

    output reg[`ysyx_23060251_reg_bus] mstatus_o,
    output reg[`ysyx_23060251_reg_bus] mtvec_o,
    output reg[`ysyx_23060251_reg_bus] mepc_o,
    output reg[`ysyx_23060251_reg_bus] mcause_o,
);
    initial begin
        mstatus_o <= h'1800;
    end


endmodule
