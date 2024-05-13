module lsu (
    input  wire clk_i,
    input  wire wenMem_i,
    input  wire renMem_i,
    // input  wire[`ysyx_23060251_store_bus] store_info_i,
    // input  wire[`ysyx_23060251_load_bus] load_info_i,
    input  wire[`ysyx_23060251_ram_bus] addr_i,
    input  wire[`ysyx_23060251_mask_bus] mask_i,
    input  wire[`ysyx_23060251_xlen_bus] wdata_i,
    output  reg[`ysyx_23060251_xlen_bus] rdata_o
);

endmodule