#include "dpic.h"
#include "debug.h"
#include "trace.h"
#include "cpu.h"
#include <stdio.h>
#include <verilated.h>
#include "verilated_dpi.h"

extern "C" void halt(uint32_t inst) {
    if (inst == EBREAK) {
        ebreak();
    }
}

static int cnt = 0;
extern "C" uint32_t fetch(bool clk, bool rst, paddr_t pc) {
    // printf("clk=%d, rst=%d, pc=" FMT_PADDR "\n", clk, rst, pc);
    if (rst && pc == 0) { 
        return NOP;
    }
    Assert(in_pmem(pc), "Out of bounds memory accsee!\n");
    uint32_t inst = paddr_read(pc, 4);
    printf("pc = " FMT_PADDR ": " FMT_WORD " at %d\n", pc, inst, cnt ++);
    return inst;
}

word_t* gprs = NULL;
extern "C" void set_gpr_ptr(const svOpenArrayHandle gpr) {
    word_t* data = (word_t *)(((VerilatedDpiOpenVar*)gpr)->datap());
    gprs = data;
}
