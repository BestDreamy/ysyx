#include "cpu.h"
#include "macro.h"
#include "trace.h"

CPU_state npc_cpu;

void cpu_init() {
    dut->clk = 0; dut->rst = 1; dut->eval();
    tfp->dump(time_counter ++);
    dut->clk = 1; dut->rst = 1; dut->eval();
    tfp->dump(time_counter ++);
    IFDEF(CONFIG_ITRACE, itrace(dut->pc, dut->inst));
    dut->rst = 0;

    init_disasm("riscv32-pc-linux-gnu");
    cpu_exec(3);
}

void exec_once() {
    dut->clk = 1 - dut->clk; // 0
    dut->eval();
    tfp->dump(time_counter ++);
    
    dut->clk = 1 - dut->clk; // 1
    dut->eval();
    tfp->dump(time_counter ++);
    IFDEF(CONFIG_ITRACE, itrace(dut->pc, dut->inst));
}

void cpu_exec(uint64_t n) {
    // cpu_init() execute the first instruction
    for (int i = 0; i < n - 1 && time_counter < 50; i ++) {
        exec_once();
    }

    IFDEF(CONFIG_ITRACE, itraceDisplay());
    IFDEF(CONFIG_MTRACE, mtraceDisplay());
}