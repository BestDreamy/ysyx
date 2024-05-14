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

    import "DPI-C" function int vaddr_read(
        bit is_signed,
        int addr,
        byte mask
    );
    always_comb begin
        if (renMem_i) rdata_o = vaddr_read(is_load_signed_i, addr_i, mask_i);
        else rdata_o = 0;
    end

    import "DPI-C" function void vaddr_write(
        int addr,
        byte mask,
        int data
    );
    always @(posedge clk_i) begin
        if (wenMem_i) vaddr_write(addr_i, mask_i, wdata_i);
    end
endmodule