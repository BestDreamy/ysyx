module ifu (
    // output                                  f_valid_o, // to D
    // input                                   D_ready_i, // form D
    input   [`ysyx_23060251_pipe_bus]       ifu2Dpipe_en_i,
    output                                  stall_o,
    output                                  sleep_o,

    input   [`ysyx_23060251_inst_bus]       inst_i,

    // pre-decode
    output  [`ysyx_23060251_pc_bus]         pc_o,
    output  [`ysyx_23060251_opinfo_bus]     opinfo_o,
    output  [`ysyx_23060251_sys_bus]        sys_info_o,
    output  [`ysyx_23060251_imm_bus]        imm_o,
    output  [`ysyx_23060251_pc_bus]         pred_pc_o,

    // branch, jalr error
    input                                   d_byp_en_i,
    input   [`ysyx_23060251_pc_bus]         d_byp_npc_i, // jalr
    input                                   e_byp_en_i,
    input                                   e_byp_cnd_i,
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
        .inst_i    (inst_i),
        .pc_i      (pc)
    );

    // bypass
    wire is_jalr, is_mret, is_ecall;

    assign is_jalr   = opinfo_o[`ysyx_23060251_opinfo_jalr];
    assign is_ecall  = sys_info_o[`ysyx_23060251_sys_ecall];
    assign is_mret   = sys_info_o[`ysyx_23060251_sys_mret];

    assign sleep_o = is_jalr | is_ecall | is_mret;

    wire branch_hazard_en = e_byp_en_i & ~e_byp_cnd_i;

    reg stall;
    // reg bubble;

    reg[`ysyx_23060251_pc_bus]   pc;

    assign pc_o = pc;

    assign stall_o = stall;

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable)
            pc <= `ysyx_23060251_pc'h8000_0000;
        // arbsel
        // 1. branch hazard
        // 2. forward pc
        // 3. normal
        else if (branch_hazard_en)
            pc <= e_byp_npc_i;
        else if (d_byp_en_i)
            pc <= d_byp_npc_i;
        else if (ifu2Dpipe_en_i)
            pc <= pred_pc_o;
    end

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable)
            stall <= 1'b0;
        // arbsel
        // 1. bypass
        // 2. pre-decode for jalr
        else if (d_byp_en_i)
            stall <= 1'b0;
        else if (sleep_o)
            stall <= 1'b1;
    end

    // always @(posedge clk_i) begin
    //     if (rst_i == `ysyx_23060251_rst_enable | branch_hazard_en)
    //         inst <= `ysyx_23060251_inst'h13;
    //     else if (r_hs) begin
    //         inst <= mst_r_data_i;
    //     end
    // end

endmodule
