// Simple Instruction Decoder
module bjp ( 
    output  [`ysyx_23060251_opinfo_bus]     opinfo_o,
    output  [`ysyx_23060251_imm_bus]        imm_o,
    output  [`ysyx_23060251_pc_bus]         pred_pc_o,

    input                                   inst_i,
    input   [`ysyx_23060251_pc_bus]         pc_i
);
    // branch       ( pc + imm)
    // jal          ( pc + imm)
    // jalr         (rs1 + imm)
    // ecall mret   (      csr)

    // assign npc_o = ((is_branch_i & cnd_i) | is_jal_i)? pc_i + imm_i
    //              : (is_jalr_i)? src1_i + imm_i
    //              : (is_ecall_i | is_mret_i)? csr_data_i
    //              : pc_i + 4;

    /****************************************************************************************
                                            opcode
    ****************************************************************************************/
    wire[`ysyx_23060251_opcode_bus] opcode = inst_i[6: 0];

    wire rv32_alu       = (opcode == 7'b01_100_11);
    wire rv32_alui      = (opcode == 7'b00_100_11);
    wire rv32_aluw      = (opcode == 7'b01_110_11);
    wire rv32_aluiw     = (opcode == 7'b00_110_11);
    wire rv32_branch    = (opcode == 7'b11_000_11);
    wire rv32_jal       = (opcode == 7'b11_011_11);
    wire rv32_jalr      = (opcode == 7'b11_001_11);
    wire rv32_load      = (opcode == 7'b00_000_11);
    wire rv32_store     = (opcode == 7'b01_000_11);
    wire rv32_lui       = (opcode == 7'b01_101_11);
    wire rv32_auipc     = (opcode == 7'b00_101_11);
    wire rv32_sys       = (opcode == 7'b11_100_11);

    assign opinfo_o = {
        rv32_sys,         // 11
        rv32_auipc,
        rv32_lui,
        rv32_store,
        rv32_load,
        rv32_jalr,
        rv32_jal,
        rv32_branch,
        rv32_aluiw,
        rv32_aluw,
        rv32_alui,
        rv32_alu          // 0
    };
 
    /****************************************************************************************
                                            imm
    ****************************************************************************************/
    // I, S, B, U, J
    wire[`ysyx_23060251_type - 1: 1] rv32_imm_sel = {
        rv32_jal,    // J-type
        rv32_lui | rv32_auipc, // U-type
        rv32_branch, // B-type
        rv32_store,  // S-type
        rv32_alui | rv32_aluiw | rv32_load | rv32_jalr | rv32_sys // I-type (omit a series of sys instruction)
    };

    igu ysyx_23060251_igu (
        .imm_sel_i(rv32_imm_sel),
        .inst_i(inst_i[`ysyx_23060251_imm_field]),
        .imm_o(imm_o)
    );

    assign pred_pc_o = (rv32_branch | rv32_jal)? pc_i + imm_o
                                               : pc_i + 4;
endmodule
