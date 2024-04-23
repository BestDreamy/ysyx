module genImm (
    // I, S, B, U, J
    input  wire[`ysyx_23060251_type - 1: 1] imm_sel_i,
    input  wire[`ysyx_23060251_inst_bus]    inst_i,
    output wire[`ysyx_23060251_imm_bus]     imm_o
);
    localparam int ext_I_imm = `ysyx_23060251_imm - 12;
    localparam int ext_S_imm = `ysyx_23060251_imm - 12;
    localparam int ext_B_imm = `ysyx_23060251_imm - 13;
    localparam int ext_U_imm = `ysyx_23060251_imm - 32;
    localparam int ext_J_imm = `ysyx_23060251_imm - 21;

    wire [`ysyx_23060251_imm_bus] rv32_I_imm = { {ext_I_imm{inst_i[31]}},
                                                 inst_i[31: 20]
                                               };
    wire [`ysyx_23060251_imm_bus] rv32_S_imm = { {ext_S_imm{inst_i[31]}},
                                                 inst_i[31:25],
                                                 inst_i[11: 7]
                                               };
    wire [`ysyx_23060251_imm_bus] rv32_B_imm = { {ext_B_imm{inst_i[31]}},
                                                 inst_i[31],
                                                 inst_i[7],
                                                 inst_i[30:25],
                                                 inst_i[11:8 ],
                                                 1'b0
                                               };
    wire [`ysyx_23060251_imm_bus] rv32_U_imm = { {ext_U_imm{inst_i[31]}},
                                                 inst_i[31:12],
                                                 12'b0
                                               };
    wire [`ysyx_23060251_imm_bus] rv32_J_imm = { {ext_J_imm{inst_i[31]}},
                                                 inst_i[31],
                                                 inst_i[19:12],
                                                 inst_i[20],
                                                 inst_i[30:21],
                                                 1'b0
                                               };

    assign imm_o = ({`ysyx_23060251_imm{imm_sel_i[1]}} & rv32_I_imm)
                 | ({`ysyx_23060251_imm{imm_sel_i[2]}} & rv32_S_imm)
                 | ({`ysyx_23060251_imm{imm_sel_i[3]}} & rv32_B_imm)
                 | ({`ysyx_23060251_imm{imm_sel_i[4]}} & rv32_U_imm)
                 | ({`ysyx_23060251_imm{imm_sel_i[5]}} & rv32_J_imm);
endmodule
