#include "dpic.h"
#include "debug.h"
#include <stdio.h>

extern "C" bool halt(uint32_t inst) {
    if (inst == EBREAK) puts("******************* ebreak triggered !!! ************************\n");
    return (inst == EBREAK);
}

extern "C" uint32_t fetch(paddr_t pc) {
    Assert(in_pmem(pc), "Out of bounds memory accsee!\n");
    return paddr_read(pc, 4);
}
