#include "dpic.h"
#include "debug.h"
#include "trace.h"
#include <stdio.h>
#include <verilated.h>

extern "C" bool halt(uint32_t inst) {
    if (inst == EBREAK) puts("******************* ebreak triggered !!! ************************\n");
    return (inst == EBREAK || inst == 0);
}

int cnt = 0;
extern "C" uint32_t fetch(bool clk, bool rst, paddr_t pc) {
    printf("clk=%d, rst=%d, pc=" FMT_PADDR "\n", clk, rst, pc);
    if (rst && pc == 0) {
        return NOP;
    }
    Assert(in_pmem(pc), "Out of bounds memory accsee!\n");
    uint32_t inst = paddr_read(pc, 4);
    // printf("pc = " FMT_PADDR ": " FMT_WORD "at %d\n", pc, inst, cnt ++);
    return inst;
}
