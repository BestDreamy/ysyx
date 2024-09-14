module exu (
    input  [`ysyx_23060251_opinfo_bus]      opinfo_i,
    input  [`ysyx_23060251_alu_bus]         alu_i,
    input  [`ysyx_23060251_branch_bus]      branch_info_i,
    input  [`ysyx_23060251_sys_bus]         sys_info_i,

    input  [`ysyx_23060251_pc_bus]          pc_i,
    input  [`ysyx_23060251_reg_bus]         src1_i,
    input  [`ysyx_23060251_reg_bus]         src2_i,
    input  [`ysyx_23060251_imm_bus]         imm_i, //offset
    input  [`ysyx_23060251_reg_bus]         csr_data_i,

    input                                   e_valid_i, // from idu
    output                                  e_ready_o, // from idu

    output                                  e_valid_o, // to lsu
    input                                   e_ready_i, // to lsu

    output [`ysyx_23060251_pc_bus]          npc_o,
    output [`ysyx_23060251_xlen_bus]        res_o,
    output                                  cnd_o
);
    assign e_valid_o = e_valid_i;
    assign e_ready_o = e_valid_i;

    alu ysyx_23060251_alu (
        .opinfo_i(opinfo_i),
        .alu_i(alu_i),
        .branch_info_i(branch_info_i),
        .sys_info_i(sys_info_i),
        .pc_i(pc_i),
        .src1_i(src1_i),
        .src2_i(src2_i),
        .imm_i(imm_i),
        .csr_data_i(csr_data_i),
        .res_o(res_o),
        .cnd_o(cnd_o)
    );

    bjp ysyx_23060251_bjp (
        .is_branch_i(opinfo_i[`ysyx_23060251_opinfo_branch]),
        .is_jal_i(opinfo_i[`ysyx_23060251_opinfo_jal]),
        .is_jalr_i(opinfo_i[`ysyx_23060251_opinfo_jalr]),
        .is_ecall_i(sys_info_i[`ysyx_23060251_sys_ecall]),
        .is_mret_i(sys_info_i[`ysyx_23060251_sys_mret]),
        .pc_i(pc_i),
        .src1_i(src1_i),
        .imm_i(imm_i),
        .cnd_i(cnd_o),
        .csr_data_i(csr_data_i),
        .npc_o(npc_o)
    );

    // agu ysyx_23060251_agu (
    //     .is_load_i(opinfo_i[`ysyx_23060251_opinfo_load]),
    //     .is_store_i(opinfo_i[`ysyx_23060251_opinfo_store]),
    //     .src1_i(src1_i),
    //     .imm_i(imm_i),
    //     .addr_o(addr_o)
    // );
endmodule
