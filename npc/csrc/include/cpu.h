#ifndef CPU_H
#define CPU_H
#include "verilated_fst_c.h"
#include "Vtop.h"
#include "paddr.h"
#include "isa.h"
typedef struct {
    // word_t gpr[32];
    word_t* gpr;
    paddr_t pc;
} CPU_state;
extern CPU_state npc_cpu;

enum { NEMU_RUNNING, NEMU_STOP, NEMU_END, NEMU_ABORT, NEMU_QUIT };

typedef struct {
  int state;
  paddr_t halt_pc;
} NPCState;
extern NPCState npc_state;

extern Vtop* dut;
extern VerilatedFstC* tfp;
#define FINISH_TIME 100
#define TIME_RESET  0 
extern uint32_t time_counter;

extern "C" void init_disasm(const char *triple);
void cpu_init();
void exec_once();
void cpu_exec(uint64_t n);
#endif