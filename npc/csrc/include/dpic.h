#ifndef DPIC_H
#define DPIC_H
#include "macro.h"
#include "isa.h"
#include "paddr.h"
#define EBREAK 0x100073

extern "C" bool halt(uint32_t inst);
extern "C" uint32_t fetch(paddr_t pc);

#endif
