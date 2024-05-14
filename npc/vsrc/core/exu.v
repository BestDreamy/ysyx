module exu (
    input  wire[`ysyx_23060251_opinfo_bus] opinfo_i,
    input  wire[`ysyx_23060251_alu_bus] alu_i,
    input  wire[`ysyx_23060251_branch_bus] branch_info_i,

    input  wire[`ysyx_23060251_pc_bus]  pc_i,
    input  wire[`ysyx_23060251_reg_bus] src1_i,
    input  wire[`ysyx_23060251_reg_bus] src2_i,
    input  wire[`ysyx_23060251_imm_bus] imm_i, //offset

    output wire[`ysyx_23060251_pc_bus]   npc_o,
    output wire[`ysyx_23060251_xlen_bus] res_o,
    output wire                          cnd_o
);

    alu ysyx_23060251_alu (
        .opinfo_i(opinfo_i),
        .alu_i(alu_i),
        .branch_info_i(branch_info_i),
        .pc_i(pc_i),
        .src1_i(src1_i),
        .src2_i(src2_i),
        .imm_i(imm_i),
        .res_o(res_o),
        .cnd_o(cnd_o)
    );

    bjp ysyx_23060251_bjp (
        .is_branch_i(opinfo_i[`ysyx_23060251_opinfo_branch]),
        .is_jal_i(opinfo_i[`ysyx_23060251_opinfo_jal]),
        .is_jalr_i(opinfo_i[`ysyx_23060251_opinfo_jalr]),
        .pc_i(pc_i),
        .src1_i(src1_i),
        .imm_i(imm_i),
        .cnd_i(cnd_o),
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
