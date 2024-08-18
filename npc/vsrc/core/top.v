`include "defines"
module top (
    input clk,
    input rst,
    output wire[`ysyx_23060251_pc_bus]   pc,
    output wire[`ysyx_23060251_inst_bus] inst
);

    pcu ysyx_23060251_pcu (
        .clk_i(clk),
        .rst_i(rst),
        .npc_i(npc),
        .pc_o(pc)
    );

    ifu ysyx_23060251_ifu (
        .clk_i(clk),
        .rst_i(rst),
        .pc_i(pc),
        .inst_o(inst)
    );

wire[`ysyx_23060251_opinfo_bus] opinfo;
wire[`ysyx_23060251_alu_bus] alu_info;
wire[`ysyx_23060251_branch_bus] branch_info;
wire[`ysyx_23060251_load_bus] load_info;
wire[`ysyx_23060251_store_bus] store_info;
wire[`ysyx_23060251_sys_bus] sys_info;
wire[`ysyx_23060251_csr_bus] csr_info;
wire wenCsr;
wire wenReg;
wire[`ysyx_23060251_rs_bus] rd;
wire[`ysyx_23060251_rs_bus] rs1;
wire[`ysyx_23060251_rs_bus] rs2;
wire[`ysyx_23060251_reg_bus] src1;
wire[`ysyx_23060251_reg_bus] src2;
wire[`ysyx_23060251_imm_bus] imm;
wire is_load_signed;
wire wenMem;
wire renMem;
wire[`ysyx_23060251_mask_bus] mask;
    idu ysyx_23060251_idu (
        .inst_i(inst),
        .opinfo_o(opinfo),
        .alu_o(alu_info),
        .branch_o(branch_info),
        .load_o(load_info),
        .store_o(store_info),
        .sys_o(sys_info),
        .csr_o(csr_info),
        .wenCsr_o(wenCsr),
        .wenReg_o(wenReg),
        .rd_o(rd),
        .rs1_o(rs1),
        .rs2_o(rs2),
        // .src1_o(src1),
        // .src2_o(src2),
        .imm_o(imm),
        .is_load_signed_o(is_load_signed),
        .wenMem_o(wenMem),
        .renMem_o(renMem),
        .mask_o(mask)
    );

    /****************************************************************************************
                                          src && csr &&wb
    ****************************************************************************************/
    regs ysyx_23060251_regs (
        .clk_i(clk),
        .rst_i(rst),
        .wen_i(wenReg),
        .rd_i(rd),
        .e_wdata_i(res),
        .is_load_i(renMem),
        .m_wdata_i(rdata),

        .rs1_i(rs1),
        .src1_o(src1),
        .rs2_i(rs2),
        .src2_o(src2)
    );

// wire[`ysyx_23060251_reg_bus] mstatus;
// wire[`ysyx_23060251_reg_bus] mtvec;
// wire[`ysyx_23060251_reg_bus] mepc;
// wire[`ysyx_23060251_reg_bus] mcause;
wire[`ysyx_23060251_reg_bus] csr_data;
    csr ysyx_23060251_csr (
        .clk_i(clk),
        .rst_i(rst),
        .is_ecall_i(sys_info[`ysyx_23060251_sys_ecall]),
        .is_mret_i(sys_info[`ysyx_23060251_sys_mret]),
        .imm_i(imm),
        .src1_i(src1),
        .mepc_i(pc),
        .mcause_i('hb),

        .data_o(csr_data)
    );
    /****************************************************************************************
                                          src && csr &&wb
    ****************************************************************************************/

wire[`ysyx_23060251_pc_bus] npc;
wire[`ysyx_23060251_xlen_bus] res;
wire cnd;
    exu ysyx_23060251_exu (
        .opinfo_i(opinfo),
        .alu_i(alu_info),
        .branch_info_i(branch_info),
        .sys_info_i(sys_info),
        .csr_info_i(csr_info),
        .pc_i(pc),
        .src1_i(src1),
        .src2_i(src2),
        .imm_i(imm),
        .csr_data_i(csr_data),
        .npc_o(npc),
        .res_o(res),
        .cnd_o(cnd)
    );

// wire[`ysyx_23060251_xlen_bus] wdata;
wire[`ysyx_23060251_xlen_bus] rdata;
    lsu ysyx_23060251_lsu (
        .clk_i(clk),
        .is_load_signed_i(is_load_signed),
        .wenMem_i(wenMem),
        .renMem_i(renMem),
        .addr_i(res),
        .mask_i(mask),
        .wdata_i(src2),
        .rdata_o(rdata)
    );

/*
    wb ysyx_23060251_wb (
        .clk_i(clk),
        .rst_i(rst),
        .opinfo_i(opinfo),
        .dst_i(dst),
        .res_i(res)
    );
*/
endmodule
