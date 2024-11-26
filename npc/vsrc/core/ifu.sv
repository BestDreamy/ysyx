module ifu (
    input                                   clk_i,
    input                                   rst_i,
    // input   [`ysyx_23060251_pc_bus]         npc_i,

    output                                  f_valid_o, // to D
    input                                   D_ready_i, // form D
    input   [`ysyx_23060251_pipe_bus]       ifu2Dpipe_en_i,

    output  [`ysyx_23060251_pc_bus]         pc_o,
    output  [`ysyx_23060251_inst_bus]       inst_o,
    output  [`ysyx_23060251_opinfo_bus]     opinfo_o,
    output  [`ysyx_23060251_sys_bus]        sys_info_o,
    output  [`ysyx_23060251_imm_bus]        imm_o,
    output  [`ysyx_23060251_pc_bus]         pred_pc_o,

    input                                   d_byp_en_i,
    input   [`ysyx_23060251_pc_bus]         d_byp_npc_i, // jalr
    input                                   e_byp_en_i,
    input                                   e_byp_cnd_i,
    input   [`ysyx_23060251_pc_bus]         e_byp_npc_i, // branch

    // AXI LITE
    output                                  mst_ar_valid_o,
    output  [`ysyx_23060251_axi_addr_bus]   mst_ar_addr_o,
    input                                   mst_ar_ready_i,

    input                                   mst_r_valid_i,
    input   [`ysyx_23060251_axi_data_bus]   mst_r_data_i,
    input   [1:0]                           mst_r_resp_i,
    output                                  mst_r_ready_o
);

    // jal branch
    bjp ysyx_bjp
    (
        .opinfo_o  (opinfo_o),
        .sys_info_o(sys_info_o),
        .imm_o     (imm_o),
        .pred_pc_o (pred_pc_o),
        .inst_i    (inst_o),
        .pc_i      (pc_o)
    );

    // bypass
    wire is_jalr, is_mret, is_ecall;

    assign is_jalr   = opinfo_o[`ysyx_23060251_opinfo_jalr];
    assign is_ecall  = sys_info_o[`ysyx_23060251_sys_ecall];
    assign is_mret   = sys_info_o[`ysyx_23060251_sys_mret];

    wire wait_decode_en = is_jalr | is_ecall | is_mret;

    wire branch_hazard_en = e_byp_en_i & ~e_byp_cnd_i;

    reg stall;
    reg bubble;

    reg[`ysyx_23060251_pc_bus]   pc;
    reg[`ysyx_23060251_inst_bus] inst;

    assign pc_o = pc;

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

    assign f_valid_o = (state == WAIT_ID_HS);
    assign inst_o    = inst;

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable)
            stall <= 1'b0;
        // arbsel
        // 1. bypass
        // 2. pre-decode for jalr
        else if (d_byp_en_i)
            stall <= 1'b0;
        else if (wait_decode_en)
            stall <= 1'b1;
    end

    // always @(posedge clk_i) begin
    //     if (rst_i == `ysyx_23060251_rst_enable)
    //         bubble <= 1'b0;
    //     else if (branch_hazard_en)
    //         bubble <= 1'b1;
    //     else if (ar_hs)
    //         bubble <= 1'b0;
    // end

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable | branch_hazard_en)
            inst <= `ysyx_23060251_inst'h13;
        else if (r_hs) begin
            inst <= mst_r_data_i;
        end
    end

    // always @(posedge clk_i) begin
    //     if (rst_i == `ysyx_23060251_rst_enable)
    // end

    // rom ysyx_23060251_rom (
    //     .clk_i(clk_i),
    //     .rst_i(rst_i),
    //     .pc_i(pc_o),
    //     .inst_o(mst_r_data_i)
    // );

    import "DPI-C" function void halt(int inst);

    always_comb halt(inst_o);

endmodule
