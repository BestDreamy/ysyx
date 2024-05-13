module lsu (
    input  wire clk_i,
    input  wire is_load_signed_i,
    input  wire wenMem_i,
    input  wire renMem_i,
    // input  wire[`ysyx_23060251_store_bus] store_info_i,
    // input  wire[`ysyx_23060251_load_bus] load_info_i,
    input  wire[`ysyx_23060251_ram_bus] addr_i,
    input  wire[`ysyx_23060251_mask_bus] mask_i,
    input  wire[`ysyx_23060251_xlen_bus] wdata_i,
    output  reg[`ysyx_23060251_xlen_bus] rdata_o
);

    import "DPI-C" function int vmem_read(
        input bit is_signed,
        input int addr,
        input byte mask
        // output int data
    );
    always_comb begin
        if (renMem_i) rdata_o = vmem_read(is_load_signed_i, addr_i, mask_i);
    end

    import "DPI-C" function void vmem_write(
        input int addr,
        input byte mask,
        input int data
    );
    always @(posedge clk_i) begin
        if (wenMem_i) vmem_write(addr_i, mask_i, wdata_i);
    end
endmodule