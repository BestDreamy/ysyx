module rom (
    input wire clk_i,
    input wire rst_i,
    input wire[`ysyx_23060251_pc_bus] pc_i,
    output reg[`ysyx_23060251_inst_bus] inst_o
);
    import "DPI-C" function int fetch(
        bit rst,
        int pc
    );
    // import "DPI-C" function int vaddr_read(
    //     bit is_signed,
    //     int addr,
    //     byte mask
    // );

    always_comb begin
        inst_o = fetch(rst_i, pc_i);
    end
endmodule
