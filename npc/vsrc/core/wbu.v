module wbu (
    input                               wb_en_i,
    input                               m_wenReg_i,
    input                               m_wenCsr_i,

    input  [`ysyx_23060251_rs_bus]      m_rd_i,
    input  [`ysyx_23060251_xlen_bus]    m_res_i,
    input                               m_renMem_i,
    input  [`ysyx_23060251_xlen_bus]    m_rdata_i,
    input  [`ysyx_23060251_sys_bus]     m_sys_info_i,
    input  [`ysyx_23060251_imm_bus]     m_imm_i,
    input  [`ysyx_23060251_reg_bus]     m_src1_i,
    input  [`ysyx_23060251_pc_bus]      m_pc_i,

    output [`ysyx_23060251_rs_bus]      w_rd_o,
    output [`ysyx_23060251_xlen_bus]    w_res_o,
    output                              w_renMem_o,
    output [`ysyx_23060251_xlen_bus]    w_rdata_o,
    output [`ysyx_23060251_sys_bus]     w_sys_info_o,
    output [`ysyx_23060251_imm_bus]     w_imm_o,
    output [`ysyx_23060251_reg_bus]     w_src1_o,
    output [`ysyx_23060251_pc_bus]      w_pc_o,

    output                              w_wenReg_o,
    output                              w_wenCsr_o



);
    assign w_wenReg_o = wb_en_i & m_wenReg_i;
    assign w_wenCsr_o = wb_en_i & m_wenCsr_i;

    assign w_rd_o       = m_rd_i;
    assign w_res_o      = m_res_i;
    assign w_renMem_o   = m_renMem_i;
    assign w_rdata_o    = m_rdata_i;
    assign w_sys_info_o = m_sys_info_i;
    assign w_imm_o      = m_imm_i;
    assign w_src1_o     = m_src1_i;
    assign w_pc_o       = m_pc_i;
endmodule

