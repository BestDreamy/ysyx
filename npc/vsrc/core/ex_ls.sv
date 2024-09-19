module ex_ls (
    input  [`ysyx_23060251_sys_bus]        e_sys_info_i,
    input                                  e_wenReg_i,
    input                                  e_wenCsr_i,
    input  [`ysyx_23060251_rs_bus]         e_rd_i,
    input  [`ysyx_23060251_reg_bus]        e_src1_i,
    input  [`ysyx_23060251_imm_bus]        e_imm_i,
    input                                  e_is_load_signed_i,
    input                                  e_wenMem_i,
    input                                  e_renMem_i,
    input  [`ysyx_23060251_mask_bus]       e_mask_i,
    input  [`ysyx_23060251_pc_bus]         e_npc_i,
    input  [`ysyx_23060251_xlen_bus]       e_res_i,
    input                                  e_cnd_i,

    input                                  e_valid_i, // from exu
    output                                 M_ready_o, // to exu

    output  [`ysyx_23060251_sys_bus]       m_sys_info_o,
    output                                 m_wenReg_o,
    output                                 m_wenCsr_o,
    output  [`ysyx_23060251_rs_bus]        m_rd_o,
    output  [`ysyx_23060251_reg_bus]       m_src1_o,
    output  [`ysyx_23060251_imm_bus]       m_imm_o,
    output                                 m_is_load_signed_o,
    output                                 m_wenMem_o,
    output                                 m_renMem_o,
    output  [`ysyx_23060251_mask_bus]      m_mask_o,
    output  [`ysyx_23060251_pc_bus]        m_npc_o,
    output  [`ysyx_23060251_xlen_bus]      m_res_o,
    output                                 m_cnd_o,

    output                                 M_valid_o,
    input                                  m_ready_i,

    input                                  clk_i,
    input                                  rst_i
);

endmodule
