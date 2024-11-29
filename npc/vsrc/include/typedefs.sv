`ifndef AXI_TYPEDEFS_H
`define AXI_TYPEDEFS_H

`define ysyx_23060251_axi_ar_addr 32 
`define ysyx_23060251_axi_r_data  32
`define ysyx_23060251_axi_aw_addr 32 
`define ysyx_23060251_axi_w_data  32
localparam axi_w_strb = `ysyx_23060251_axi_w_data >> 3;
`define ysyx_23060251_axi_w_strb axi_w_strb

`define ysyx_23060251_axi_ar_addr_bus `ysyx_23060251_axi_ar_addr - 1: 0
`define ysyx_23060251_axi_r_data_bus `ysyx_23060251_axi_r_data - 1: 0
`define ysyx_23060251_axi_aw_addr_bus `ysyx_23060251_axi_aw_addr - 1: 0
`define ysyx_23060251_axi_w_data_bus `ysyx_23060251_axi_w_data - 1: 0
`define ysyx_23060251_axi_w_strb_bus `ysyx_23060251_axi_w_strb - 1: 0

typedef logic[`ysyx_23060251_axi_ar_addr_bus]    axi_ar_addr_t;
typedef logic[`ysyx_23060251_axi_r_data_bus]     axi_r_data_t;
typedef logic[`ysyx_23060251_axi_aw_addr_bus]    axi_aw_addr_t;
typedef logic[`ysyx_23060251_axi_w_data_bus]     axi_w_data_t;
typedef logic[`ysyx_23060251_axi_w_strb_bus]     axi_w_strb_t;
typedef logic[3: 0]     axi_id_t;
typedef logic[2: 0]     axi_size_t;
typedef logic[7: 0]     axi_len_t;
typedef logic[1: 0]     axi_burst_t;
typedef logic[1: 0]     axi_resp_t;

`endif

