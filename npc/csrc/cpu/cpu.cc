#include "cpu.h"
#include "macro.h"
#include "trace.h"
#include "reg.h"
#include "dut.h"
#include "debug.h"
#include "init.h"
#include "sdb.h"
#include "device.h"

CPU_state npc_cpu;

void cpu_init() { // exe the first instruction
    dut->clk = 0; dut->rst = 1; dut->eval();
    tfp->dump(time_counter ++);
    dut->clk = 1; dut->rst = 1; dut->eval(); // pc -> 0x0000_0000
    tfp->dump(time_counter ++);

    // npc_cpu.pc = dut->pc;

    // Execute the first instruction
    dut->rst = 0;

    // IFDEF(CONFIG_ITRACE, itrace(dut->pc, dut->inst));

    init_disasm("riscv32-pc-linux-gnu");

    npc_eval();

    IFDEF(CONFIG_DIFFTEST, init_difftest(diff_so_file, img_size, difftest_port));

    // difftest_skip_ref();

    cpu_exec(-1);
}

void exec_once() {
    dut->clk = 1 - dut->clk; // 0
    dut->eval();
    tfp->dump(time_counter ++);
    
    dut->clk = 1 - dut->clk; // 1
    dut->eval();
    tfp->dump(time_counter ++);

    // previous inst commit
    if (dut->pc != npc_cpu.pc) {
        IFDEF(CONFIG_ITRACE, itrace(dut->pc, dut->inst));

        if (npc_cpu.pc == 0) {
            difftest_skip_ref();
            syn_difftest();
        }

        npc_eval();

        IFDEF(CONFIG_DIFFTEST, difftest_step(npc_cpu.pc, npc_cpu.pc + 4));

    }
}

void cpu_exec(uint64_t n) {
    if (n > 1) npc_state.state = NPC_RUNNING;
    
    for (int i = 0; i < n - 1; i ++) {
        exec_once();

        if (time_counter >= FINISH_TIME || (npc_state.state == NPC_RUNNING && npc_state.halt_ret)) {
            npc_state.state = NPC_END;
            break;
        }

        if (npc_state.state != NPC_RUNNING) break;

        IFDEF(CONFIG_DEVICE, device_update());
    }

    IFDEF(CONFIG_MTRACE, mtraceDisplay());

    IFDEF(CONFIG_ITRACE, itraceDisplay());

    switch (npc_state.state) {
        case NPC_RUNNING: npc_state.state = NPC_STOP; break;

        case NPC_END: case NPC_ABORT:

            Log("npc: %s at pc = " FMT_WORD,
                (npc_state.state == NPC_ABORT ? ANSI_FMT("ABORT", RED_TXT) :
                (npc_state.state == NPC_END ? ANSI_FMT("HIT GOOD TRAP", GREEN_TXT) :
                ANSI_FMT("HIT BAD TRAP", RED_TXT))),
                npc_state.halt_pc);

        // case NPC_QUIT: statistic();
    }
}

void ebreak() {
    npc_state.halt_ret = 1;
    npc_state.halt_pc = npc_cpu.pc;
}

void npc_eval() {
    // 1. In the top's interface
    npc_cpu.pc = dut->pc;
    // 2. Use dpic
    for (int i = 0; i < 32; i ++) {
        npc_cpu.gpr[i] = gprs[i];
    }
    npc_cpu.mstatus = dut->mstatus;
    npc_cpu.mtvec = dut->mtvec;
    npc_cpu.mepc = dut->mepc;
    npc_cpu.mcause = dut->mcause;
}