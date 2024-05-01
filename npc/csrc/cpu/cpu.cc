#include "cpu.h"
#include "macro.h"
#include "trace.h"

CPU_state npc_cpu;

void cpu_init() {
    dut->clk = 1; 
    dut->rst = 1;
    cpu_exec(3);
}

void exec_once() {
    dut->clk = 1 - dut->clk;
    dut->eval();
    tfp->dump(time_counter ++);
    
    dut->clk = 1 - dut->clk;
    dut->eval();
    tfp->dump(time_counter ++);
}

void cpu_exec(uint64_t n) {
    for (int i = 0; i < n && time_counter < 50; i ++) {
        if (time_counter == 2) {
            dut->rst = 0;
        }
        exec_once();
    }

    IFDEF(CONFIG_ITRACE, itraceDisplay());
    IFDEF(CONFIG_MTRACE, mtraceDisplay());
}