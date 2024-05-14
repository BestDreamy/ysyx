#ifndef DPIC_H
#define DPIC_H
#include "macro.h"
#include "isa.h"
#include "paddr.h"
#include <svdpi.h>
#define EBREAK 0x100073
#define NOP    0x13

extern "C" void halt(uint32_t inst);
extern "C" uint32_t fetch(bool clk, bool rst, paddr_t pc);
extern "C" void set_gpr_ptr(const svOpenArrayHandle gpr);
extern "C" word_t vaddr_read(bool is_signed, paddr_t addr, uint8_t mask);
extern "C" void vaddr_write(paddr_t addr, uint8_t mask, word_t data);
#endif
