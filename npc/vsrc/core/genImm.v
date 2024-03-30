module genImm (
    // I, S, B, U, J
    input  wire[`ysyx_23060251_type - 1: 1] imm_sel_i,
    input  wire[`ysyx_23060251_inst_bus]    inst_i,
    output wire[`ysyx_23060251_imm_bus]     imm_o
);

    wire [`ysyx_23060251_imm_bus] rv64_I_imm = { {52{inst_i[31]}},
                                                 inst_i[31: 20]
                                               };
    wire [`ysyx_23060251_imm_bus] rv64_S_imm = { {52{inst_i[31]}},
                                                 inst_i[31:25],
                                                 inst_i[11: 7]
                                               };
    wire [`ysyx_23060251_imm_bus] rv64_B_imm = { {51{inst_i[31]}},
                                                 inst_i[31],
                                                 inst_i[7],
                                                 inst_i[30:25],
                                                 inst_i[11:8 ],
                                                 1'b0
                                               };
    wire [`ysyx_23060251_imm_bus] rv64_U_imm = { {32{inst_i[31]}},
                                                 inst_i[31:12],
                                                 12'b0
                                               };
    wire [`ysyx_23060251_imm_bus] rv64_J_imm = { {43{inst_i[31]}},
                                                 inst_i[31],
                                                 inst_i[19:12],
                                                 inst_i[20],
                                                 inst_i[30:21],
                                                 1'b0
                                               };

    assign imm_o =
        ({`ysyx_23060251_imm{imm_sel_i[1]}} & rv64_I_imm) |
        ({`ysyx_23060251_imm{imm_sel_i[2]}} & rv64_S_imm) |
        ({`ysyx_23060251_imm{imm_sel_i[3]}} & rv64_B_imm) |
        ({`ysyx_23060251_imm{imm_sel_i[4]}} & rv64_U_imm) |
        ({`ysyx_23060251_imm{imm_sel_i[5]}} & rv64_J_imm)
    ;
endmodule
