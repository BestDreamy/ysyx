#include "cpu.h"
#include "macro.h"
#include "trace.h"
#include "reg.h"

CPU_state npc_cpu;

void cpu_init() { // exe the first instruction
    dut->clk = 0; dut->rst = 1; dut->eval();
    tfp->dump(time_counter ++);
    dut->clk = 1; dut->rst = 1; dut->eval();
    tfp->dump(time_counter ++);
    // Execute the first instruction
    dut->rst = 0;
    
    IFDEF(CONFIG_ITRACE, itrace(dut->pc, dut->inst));

    init_disasm("riscv32-pc-linux-gnu");

    isa_reg_display();

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

    isa_reg_display();
}

void cpu_exec(uint64_t n) {
    for (int i = 0; i < n - 1 && time_counter < 50; i ++) {
        exec_once();
    }

    IFDEF(CONFIG_ITRACE, itraceDisplay());
    IFDEF(CONFIG_MTRACE, mtraceDisplay());
}