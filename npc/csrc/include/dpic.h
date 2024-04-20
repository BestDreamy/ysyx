#ifndef DPIC_H
#define DPIC_H
#include "macro.h"
#include "isa.h"

extern "C" bool halt(uint32 inst);
extern "C" uint32 fetch(paddr pc);

#endif
