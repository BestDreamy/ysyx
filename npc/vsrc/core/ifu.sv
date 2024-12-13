module ifu (
    axi_ar_if                               f_mst_ar,
    axi_r_if                                f_mst_r,

    input   [`ysyx_23060251_pipe_bus]       ifu2Dpipe_en_i, // pulse
    output                                  f_valid_o, // to D
    output  [`ysyx_23060251_inst_bus]       inst_o,
    // pre-decode
    output  [`ysyx_23060251_pc_bus]         pc_o,
    output  [`ysyx_23060251_opinfo_bus]     opinfo_o,
    output  [`ysyx_23060251_sys_bus]        sys_info_o,
    output  [`ysyx_23060251_imm_bus]        imm_o,
    output  [`ysyx_23060251_pc_bus]         pred_pc_o,
    // pre-decode end

    // jump error (branch, jalr)
    input                                   e_byp_en_i,
    input                                   e_branch_hazard_i,
    input   [`ysyx_23060251_pc_bus]         e_byp_npc_i, // branch

    input                                   clk_i,
    input                                   rst_i
);

    // jal 
    // branch
    bjp ysyx_bjp
    (
        .opinfo_o  (opinfo_o),
        .sys_info_o(sys_info_o),
        .imm_o     (imm_o),
        .pred_pc_o (pred_pc_o),
        .inst_i    (inst_o),
        .pc_i      (pc_o)
    );

    wire branch_hazard_d = e_byp_en_i & e_branch_hazard_i;

    reg[`ysyx_23060251_pc_bus]   pc_q;

    assign pc_o = pc_q;

    // assign stall_o = stall_q;

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable)
            pc_q <= `ysyx_23060251_pc'h8000_0000;
        // arbsel
        // 1. branch hazard
        // 2. forward pc
        // 3. normal
        else if (branch_hazard_d)
            pc_q <= e_byp_npc_i;
        else if (ifu2Dpipe_en_i)
            pc_q <= pred_pc_o;
    end

    icache ysyx_icache
    (
        .axi_mst_ar         (f_mst_ar),
        .axi_mst_r          (f_mst_r),
        .pc_i               (pc_o),
        .ifu2Dpipe_en_i     (ifu2Dpipe_en_i),
        // .f_stall_i          (f_stall),
        // .f_stall_en_i       (f_stall_en),
        .e_byp_en_i         (e_byp_en_i),
        .e_branch_hazard_i  (e_branch_hazard_i),
        .inst_o             (inst_o),
        .f_valid_o          (f_valid_o),
        .clk_i              (clk_i),
        .rst_i              (rst_i)
    );

endmodule
