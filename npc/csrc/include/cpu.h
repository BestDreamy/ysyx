#ifndef CPU_H
#define CPU_H
#include "verilated_fst_c.h"
#include "Vtop.h"
#include "paddr.h"
#include "isa.h"
typedef struct {
    word_t gpr[32];
    paddr_t pc;

    word_t mstatus;
    word_t mtvec;
    word_t mepc;
    word_t mcause;
} CPU_state;
extern word_t* gprs;
extern CPU_state npc_cpu;

extern Vtop* dut;
extern VerilatedFstC* tfp;
const int FINISH_TIME = 1e4 + 500;
#define TIME_RESET  0 
extern uint32_t time_counter;

extern "C" void init_disasm(const char *triple);
void cpu_init();
void exec_once();
void cpu_exec(uint64_t n);
void ebreak();
void npc_eval();
#endif