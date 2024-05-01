#include "dpic.h"
#include "debug.h"
#include "trace.h"
#include <stdio.h>

extern "C" bool halt(uint32_t inst) {
    if (inst == EBREAK) puts("******************* ebreak triggered !!! ************************\n");
    return (inst == EBREAK || inst == 0);
}

extern "C" uint32_t fetch(paddr_t pc, bool rst) {
    if (rst) return NOP;
    Assert(in_pmem(pc), "Out of bounds memory accsee!\n");
    uint32_t inst = paddr_read(pc, 4);
    IFDEF(CONFIG_ITRACE, itrace(pc, inst));
    printf("pc = " FMT_PADDR ": " FMT_WORD "\n", pc, inst);
    return inst;
}
