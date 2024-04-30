#ifndef CPU_H
#define CPU_H
#include "verilated_fst_c.h"
#include "Vtop.h"
#include "paddr.h"
#include "isa.h"
typedef struct {
    word_t gpr[32];
    paddr_t pc;
} CPU_state;
extern CPU_state npc_cpu;
extern Vtop* dut;
extern VerilatedFstC* tfp;

void cpu_init();
void exec_once();
void cpu_exec();
#endif