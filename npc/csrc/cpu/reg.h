#ifndef REG_H
#define REG_H
#include "cpu.h"
extern const char *regs[];

void isa_reg_display(CPU_state cpu);
#endif