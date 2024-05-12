module agu (
    input  wire is_load_i,
    input  wire is_store_i,
    input  wire[`ysyx_23060251_reg_bus] src1_i,
    input  wire[`ysyx_23060251_imm_bus] imm_i,

    output wire[`ysyx_23060251_ram_bus] addr_o
);

    assign addr_o = {`ysyx_23060251_ram{is_load_i | is_store_i}} & (src1_i + imm_i);
endmodule