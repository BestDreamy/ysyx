#include "cpu.h"
#include "macro.h"
#include "trace.h"

CPU_state npc_cpu;

void cpu_init() {
    dut->clk = 0; dut->rst = 1; dut->eval();
    printf("******************************\n");
    tfp->dump(time_counter ++);
    // dut->clk = 1; dut->rst = 0; // dut->eval();
    // tfp->dump(time_counter ++);
    // dut->clk = 0; dut->rst = 1; dut->eval();
    // tfp->dump(time_counter ++);
    // dut->clk = 1; dut->rst = 0; dut->eval();
    // tfp->dump(time_counter ++);
    // dut->clk = 0; dut->rst = 0; dut->eval();
    // tfp->dump(time_counter ++);

    init_disasm("riscv32-pc-linux-gnu");
    cpu_exec(4);
}

void exec_once() {
    dut->clk = 1 - dut->clk; // 1
    dut->eval();
    printf("******************************\n");
    tfp->dump(time_counter ++);
    
    dut->clk = 1 - dut->clk; // 0
    dut->eval();
    printf("******************************\n");
    tfp->dump(time_counter ++);
}

void cpu_exec(uint64_t n) {
    for (int i = 0; i < n && time_counter < 50; i ++) {
        exec_once();
    dut->rst = 0;
    }

    IFDEF(CONFIG_ITRACE, itraceDisplay());
    IFDEF(CONFIG_MTRACE, mtraceDisplay());
}