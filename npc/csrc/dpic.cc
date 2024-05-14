#include "dpic.h"
#include "debug.h"
#include "trace.h"
#include "cpu.h"
#include "paddr.h"
#include <stdio.h>
#include <verilated.h>
#include "verilated_dpi.h"

void halt(uint32_t inst) {
    if (inst == EBREAK || inst == 0x6f) {
        ebreak();
    }
}

static int cnt = 0;
uint32_t fetch(bool clk, bool rst, paddr_t pc) {
    // printf("clk=%d, rst=%d, pc=" FMT_PADDR "\n", clk, rst, pc);
    if (rst && pc == 0) { 
        return NOP;
    }
    Assert(in_pmem(pc), "Out of bounds memory accsee!\n");
    uint32_t inst = paddr_read(pc, 4);
    // printf("pc = " FMT_PADDR ": " FMT_WORD " at %d\n", pc, inst, cnt ++);
    return inst;
}

word_t* gprs = NULL;
void set_gpr_ptr(const svOpenArrayHandle gpr) {
    word_t* data = (word_t *)(((VerilatedDpiOpenVar*)gpr)->datap());
    gprs = data;
}

word_t vaddr_read(bool is_signed, paddr_t addr, uint8_t mask) {
    word_t data = paddr_read(addr, 1 << mask);
    if (is_signed) {
        int size_of_word = sizeof(data) * 8;
        switch (mask) {
            case 0: data = (data << size_of_word -  8) >> size_of_word -  8; break;
            case 1: data = (data << size_of_word - 16) >> size_of_word - 16; break;
            // lwu: rv64
            IFDEF(CONFIG_ISA64, case 2: data = (data << size_of_word - 32) >> size_of_word - 32; break;);
        }
    }
    IFDEF(CONFIG_MTRACE, mtrace('r', addr, data));
    return data;
}

void vaddr_write(paddr_t addr, uint8_t mask, word_t data) {
    IFDEF(CONFIG_MTRACE, mtrace('w', addr, data));
    paddr_write(addr, 1 << mask, data);
}
