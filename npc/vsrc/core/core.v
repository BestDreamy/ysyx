`include "defines"
`include "typedefs"
`include "assign"

module core (
    output wire[`ysyx_23060251_pc_bus]   pc, // to wb
    output wire[`ysyx_23060251_reg_bus]  mstatus, // just for diff
    output wire[`ysyx_23060251_reg_bus]  mtvec,   // just for diff
    output wire[`ysyx_23060251_reg_bus]  mepc,    // just for diff
    output wire[`ysyx_23060251_reg_bus]  mcause,  // just for diff
    output wire[`ysyx_23060251_inst_bus] inst, // to idu

    input          io_master_awready, output          io_slave_awready,
    output         io_master_awvalid, input           io_slave_awvalid,
    output[31:0]   io_master_awaddr , input[31:0]     io_slave_awaddr,
    output[3:0]    io_master_awid   , input[3:0]      io_slave_awid,
    output[7:0]    io_master_awlen  , input[7:0]      io_slave_awlen,
    output[2:0]    io_master_awsize , input[2:0]      io_slave_awsize,
    output[1:0]    io_master_awburst, input[1:0]      io_slave_awburst,

    input          io_master_wready , output          io_slave_wready,
    output         io_master_wvalid , input           io_slave_wvalid,
    output[31:0]   io_master_wdata  , input[31:0]     io_slave_wdata,
    output[3:0]    io_master_wstrb  , input[3:0]      io_slave_wstrb,
    output         io_master_wlast  , input           io_slave_wlast,

    output         io_master_bready , input           io_slave_bready,
    input          io_master_bvalid , output          io_slave_bvalid,
    input[1:0]     io_master_bresp  , output[1:0]     io_slave_bresp,
    input[3:0]     io_master_bid    , output[3:0]     io_slave_bid,

    input          io_master_arready, output          io_slave_arready,
    output         io_master_arvalid, input           io_slave_arvalid,
    output[31:0]   io_master_araddr , input[31:0]     io_slave_araddr,
    output[3:0]    io_master_arid   , input[3:0]      io_slave_arid,
    output[7:0]    io_master_arlen  , input[7:0]      io_slave_arlen,
    output[2:0]    io_master_arsize , input[2:0]      io_slave_arsize,
    output[1:0]    io_master_arburst, input[1:0]      io_slave_arburst,

    output         io_master_rready , input           io_slave_rready,
    input          io_master_rvalid , output          io_slave_rvalid,
    input[1:0]     io_master_rresp  , output[1:0]     io_slave_rresp,
    input[31:0]    io_master_rdata  , output[31:0]    io_slave_rdata,
    input          io_master_rlast  , output          io_slave_rlast,
    input[3:0]     io_master_rid    , output[3:0]     io_slave_rid,

    input clk,
    input rst
);
    wire                                inst_wb;
    wire [`ysyx_23060251_pc_bus]        npc;
    wire                                f_valid;
    wire                                D_ready;

    ifu ysyx_ifu
    (
        .clk_i          (clk),
        .rst_i          (rst),
        .pre_inst_wb    (inst_wb),
        .npc_i          (npc),
        .f_valid_o      (f_valid),
        .D_ready_i      (D_ready),
        .pc_o           (pc),
        .inst_o         (inst),
        .mst_ar_valid_o (io_master_arvalid),
        .mst_ar_addr_o  (io_master_araddr),
        .mst_ar_ready_i (io_master_arready),
        .mst_r_valid_i  (io_master_rvalid),
        .mst_r_data_i   (io_master_rdata),
        .mst_r_resp_i   (io_master_rresp),
        .mst_r_ready_o  (io_master_rready)
    );

    wire                                D_valid;
    wire                                d_ready;
    wire [`ysyx_23060251_inst_bus]      d_inst; // to idu
    wire [`ysyx_23060251_pc_bus]        d_pc; // to exu

    if_id ysyx_if_id
    (
        .f_inst_i  (inst),
        .f_pc_i    (pc),
        .f_valid_i (f_valid),
        .D_ready_o (D_ready),
        .d_inst_o  (d_inst),
        .d_pc_o    (d_pc),
        .D_valid_o (D_valid),
        .d_ready_i (d_ready),
        .clk_i     (clk),
        .rst_i     (rst)
    );

    wire                                d_valid;
    wire                                E_ready;
    wire [`ysyx_23060251_opinfo_bus]    d_opinfo; // to exu
    wire [`ysyx_23060251_alu_bus]       d_alu_info; // to exu
    wire [`ysyx_23060251_branch_bus]    d_branch_info; // to exu
    // wire [`ysyx_23060251_load_bus]      d_load_info;
    // wire [`ysyx_23060251_store_bus]     d_store_info;
    wire [`ysyx_23060251_sys_bus]       d_sys_info; // to wb
    wire                                d_wenReg; // to wb
    wire                                d_wenCsr; // to wb
    wire [`ysyx_23060251_rs_bus]        d_rd; // to wb
    wire [`ysyx_23060251_rs_bus]        d_rs1;
    wire [`ysyx_23060251_rs_bus]        d_rs2;
    wire [`ysyx_23060251_reg_bus]       d_src1; // to wb
    wire [`ysyx_23060251_reg_bus]       d_src2; // to exu
    wire [`ysyx_23060251_imm_bus]       d_imm;  // to wb
    wire                                d_is_load_signed; // to lsu
    wire                                d_wenMem; // to lsu
    wire                                d_renMem; // to lsu
    wire [`ysyx_23060251_mask_bus]      d_mask; // to lsu
    wire [`ysyx_23060251_reg_bus]       d_csr_data; // to exu

    idu ysyx_idu
    (
        .inst_i           (d_inst),
        .d_valid_i        (D_valid),
        .d_ready_o        (d_ready),
        .d_valid_o        (d_valid),
        .d_ready_i        (E_ready),
        .opinfo_o         (d_opinfo),
        .alu_info_o       (d_alu_info),
        .branch_info_o    (d_branch_info),
        .load_info_o      (),
        .store_info_o     (),
        .sys_info_o       (d_sys_info),
        .wenReg_o         (d_wenReg),
        .wenCsr_o         (d_wenCsr),
        .rd_o             (d_rd),
        .rs1_o            (d_rs1),
        .rs2_o            (d_rs2),
        .imm_o            (d_imm),
        .is_load_signed_o (d_is_load_signed),
        .wenMem_o         (d_wenMem),
        .renMem_o         (d_renMem),
        .mask_o           (d_mask)
    );

    /****************************************************************************************
                                          src && csr && wb
    ****************************************************************************************/
    wire                                w_wenReg;
    wire [`ysyx_23060251_rs_bus]        w_rd;
    wire[`ysyx_23060251_xlen_bus]       w_res;
    wire                                w_renMem;
    wire[`ysyx_23060251_xlen_bus]       w_rdata;
    wire                                w_wenCsr;
    wire [`ysyx_23060251_sys_bus]       w_sys_info;
    wire [`ysyx_23060251_imm_bus]       w_imm;
    wire [`ysyx_23060251_reg_bus]       w_src1;
    wire [`ysyx_23060251_pc_bus]        w_pc;
    // wire [`ysyx_23060251_reg_bus]       w_csr_data;

    regs ysyx_23060251_regs (
        .clk_i      (clk),
        .rst_i      (rst),
        .wen_i      (w_wenReg),
        .rd_i       (w_rd),
        .e_wdata_i  (w_res),
        .is_load_i  (w_renMem),
        .m_wdata_i  (w_rdata),

        .rs1_i      (d_rs1),
        .src1_o     (d_src1),
        .rs2_i      (d_rs2),
        .src2_o     (d_src2)
    );

    csr ysyx_23060251_csr (
        .clk_i      (clk),
        .rst_i      (rst),
        .wenCsr_i   (w_wenCsr),
        .is_ecall_i (w_sys_info[`ysyx_23060251_sys_ecall]),
        .is_mret_i  (w_sys_info[`ysyx_23060251_sys_mret]),
        .imm_i      (w_imm),
        .src1_i     (w_src1),
        .mepc_i     (w_pc),
        .mcause_i   ('hb),

        .mstatus_o  (mstatus),
        .mtvec_o    (mtvec),
        .mepc_o     (mepc),
        .mcause_o   (mcause),
        .data_o     (d_csr_data)
    );


    wire [`ysyx_23060251_opinfo_bus]    e_opinfo;
    wire [`ysyx_23060251_alu_bus]       e_alu_info;
    wire [`ysyx_23060251_branch_bus]    e_branch_info;
    wire [`ysyx_23060251_sys_bus]       e_sys_info;
    wire                                e_wenReg;
    wire                                e_wenCsr;
    wire [`ysyx_23060251_reg_bus]       e_csr_data;
    wire [`ysyx_23060251_rs_bus]        e_rd;
    wire [`ysyx_23060251_reg_bus]       e_src1;
    wire [`ysyx_23060251_reg_bus]       e_src2;
    wire [`ysyx_23060251_imm_bus]       e_imm;
    wire                                e_is_load_signed;
    wire                                e_wenMem;
    wire                                e_renMem;
    wire [`ysyx_23060251_mask_bus]      e_mask;
    wire [`ysyx_23060251_pc_bus]        e_pc;
    wire                                E_valid;
    wire                                e_ready;

    id_ex inst_id_ex
    (
        .d_opinfo_i         (d_opinfo),
        .d_alu_info_i       (d_alu_info),
        .d_branch_info_i    (d_branch_info),
        .d_sys_info_i       (d_sys_info),
        .d_wenReg_i         (d_wenReg),
        .d_wenCsr_i         (d_wenCsr),
        .d_csr_data_i       (d_csr_data),
        .d_rd_i             (d_rd),
        .d_src1_i           (d_src1),
        .d_src2_i           (d_src2),
        .d_imm_i            (d_imm),
        .d_is_load_signed_i (d_is_load_signed),
        .d_wenMem_i         (d_wenMem),
        .d_renMem_i         (d_renMem),
        .d_mask_i           (d_mask),
        .d_pc_i             (d_pc),
        .d_valid_i          (d_valid),
        .E_ready_o          (E_ready),
        .e_opinfo_o         (e_opinfo),
        .e_alu_info_o       (e_alu_info),
        .e_branch_info_o    (e_branch_info),
        .e_sys_info_o       (e_sys_info),
        .e_wenReg_o         (e_wenReg),
        .e_wenCsr_o         (e_wenCsr),
        .e_csr_data_o       (e_csr_data),
        .e_rd_o             (e_rd),
        .e_src1_o           (e_src1),
        .e_src2_o           (e_src2),
        .e_imm_o            (e_imm),
        .e_is_load_signed_o (e_is_load_signed),
        .e_wenMem_o         (e_wenMem),
        .e_renMem_o         (e_renMem),
        .e_mask_o           (e_mask),
        .e_pc_o             (e_pc),
        .E_valid_o          (E_valid),
        .e_ready_i          (e_ready),
        .clk_i              (clk),
        .rst_i              (rst)
    );
    /****************************************************************************************
                                          src && csr && wb
    ****************************************************************************************/

    wire                            e_valid;
    wire                            e_ready;
    wire [`ysyx_23060251_pc_bus]    e_npc;
    wire [`ysyx_23060251_xlen_bus]  e_res;
    wire                            e_cnd;

    exu ysyx_23060251_exu (
        .opinfo_i         (e_opinfo),
        .alu_i            (e_alu_info),
        .branch_info_i    (e_branch_info),
        .sys_info_i       (e_sys_info),
        .pc_i             (e_pc),
        .src1_i           (e_src1),
        .src2_i           (e_src2),
        .imm_i            (e_imm),
        .csr_data_i       (e_csr_data),
        .E_valid_i        (E_valid),
        .e_ready_o        (e_ready),
        .e_valid_o        (e_valid),
        .M_ready_i        (M_ready),
        .npc_o            (e_npc),
        .res_o            (e_res),
        .cnd_o            (e_cnd)
    );

// wire lsu_ready;
// // wire[`ysyx_23060251_xlen_bus] wdata;
// wire[`ysyx_23060251_xlen_bus] rdata;

//     lsu ysyx_23060251_lsu (
//         .clk_i(clk),
//         .is_load_signed_i(is_load_signed),
//         .wenMem_i(wenMem),
//         .renMem_i(renMem),
//         .addr_i(res),
//         .mask_i(mask),
//         .wdata_i(src2),
//         .rdata_o(rdata)
//     );

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
