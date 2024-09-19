module ex_ls (
    input  [`ysyx_23060251_sys_bus]        e_sys_info_i,
    input                                  e_wenReg_i,
    input                                  e_wenCsr_i,
    input  [`ysyx_23060251_rs_bus]         e_rd_i,
    input  [`ysyx_23060251_reg_bus]  	   e_src1_i,
    input  [`ysyx_23060251_imm_bus]        e_imm_i,
    input                                  e_is_load_signed_i,
    input                                  e_wenMem_i,
    input                                  e_renMem_i,
    input  [`ysyx_23060251_mask_bus]       e_mask_i,
    input  [`ysyx_23060251_pc_bus]    	   e_npc,
    input  [`ysyx_23060251_xlen_bus]  	   e_res,
    input                              	   e_cnd,

    input                                  e_valid_i, // from exu
    output                                 M_ready_o, // to exu

    input  [`ysyx_23060251_sys_bus]        m_sys_info_i,
    input                                  m_wenReg_i,
    input                                  m_wenCsr_i,
    input  [`ysyx_23060251_rs_bus]         m_rd_i,
    input  [`ysyx_23060251_reg_bus]  	   m_src1_i,
    input  [`ysyx_23060251_imm_bus]        m_imm_i,
    input                                  m_is_load_signed_i,
    input                                  m_wenMem_i,
    input                                  m_renMem_i,
    input  [`ysyx_23060251_mask_bus]       m_mask_i,
    input  [`ysyx_23060251_pc_bus]    	   m_npc,
    input  [`ysyx_23060251_xlen_bus]  	   m_res,
    input                              	   m_cnd,

    input   							   clk_i,
    input 								   rst_i
);

endmodule