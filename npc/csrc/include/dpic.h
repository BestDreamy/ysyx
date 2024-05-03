#ifndef DPIC_H
#define DPIC_H
#include "macro.h"
#include "isa.h"
#include "paddr.h"
#include <svdpi.h>
#define EBREAK 0x100073
#define NOP    0x13

extern "C" bool halt(uint32_t inst);
extern "C" uint32_t fetch(bool clk, bool rst, paddr_t pc);
extern "C" void set_gpr_ptr(const svOpenArrayHandle gpr);
#endif
