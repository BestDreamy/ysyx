#ifndef CPU_H
#define CPU_H
#include "isa.h"
#include "paddr.h"
typedef struct {
    word_t gpr[32];
    paddr_t pc;
} CPU_state;

CPU_state npc_cpu;
#endif