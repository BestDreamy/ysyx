#include "cpu.h"
#include "macro.h"
#include "trace.h"
#include "reg.h"
#include "dut.h"
#include "debug.h"
#include "init.h"
#include "sdb.h"

CPU_state npc_cpu;
NPC_state npc_state = {.state = NPC_STOP, .halt_ret = 0};

void cpu_init() { // exe the first instruction
    dut->clk = 0; dut->rst = 1; dut->eval();
    tfp->dump(time_counter ++);
    dut->clk = 1; dut->rst = 1; dut->eval();
    tfp->dump(time_counter ++);
    // Execute the first instruction
    dut->rst = 0;
    
    IFDEF(CONFIG_ITRACE, itrace(dut->pc, dut->inst));

    init_disasm("riscv32-pc-linux-gnu");

    npc_cpu.pc = dut->pc;

    // isa_reg_display();

    IFDEF(CONFIG_DIFFTEST, init_difftest(diff_so_file, img_size, difftest_port));

    cpu_exec(4);
}

void exec_once() {
    dut->clk = 1 - dut->clk; // 0
    dut->eval();
    tfp->dump(time_counter ++);
    
    dut->clk = 1 - dut->clk; // 1
    dut->eval();
    tfp->dump(time_counter ++);

    IFDEF(CONFIG_ITRACE, itrace(dut->pc, dut->inst));

    npc_cpu.pc = dut->pc;

    // isa_reg_display();

    IFDEF(CONFIG_DIFFTEST, difftest_step(npc_cpu.pc, npc_cpu.pc + 4));
}

void cpu_exec(uint64_t n) {
    for (int i = 0; i < n - 1 && time_counter < FINISH_TIME; i ++) {
        exec_once();

    switch (npc_state.state) {
        case NPC_RUNNING: npc_state.state = NPC_STOP; break;

        case NPC_END: case NPC_ABORT:

        IFDEF(CONFIG_MTRACE, mtraceDisplay());

        IFDEF(CONFIG_ITRACE, itraceDisplay());

        Log("npc: %s at pc = " FMT_WORD,
            (npc_state.state == NPC_ABORT ? ANSI_FMT("ABORT", RED_TXT) :
            (npc_state.halt_ret == 0 ? ANSI_FMT("HIT GOOD TRAP", GREEN_TXT) :
            ANSI_FMT("HIT BAD TRAP", RED_TXT))),
            npc_state.halt_pc);

        // case NPC_QUIT: statistic();
  }
    }
}

void ebreak() {
    npc_state.halt_ret = 1;
    npc_state.halt_pc = npc_cpu.pc;
}