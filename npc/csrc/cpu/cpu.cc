#include "cpu.h"

CPU_state npc_cpu;

void cpu_init() {
    dut->clk = 1; 
    dut->rst = 1;
}

void exec_once() {}
void cpu_exec(uint64_t n) {}