#include "reg.h"
#include "macro.h"
#include "cpu.h"
#include <stdio.h>
const char *regs[] = {
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};
#define gpr(i) (npc_cpu.gpr[i])

void isa_reg_display() {
    printf(BOLD_TXT "NPC Registers:\n" RESET_TXT);
    printf("pc\t0x%x(%d)\n", npc_cpu.pc, npc_cpu.pc);
    for (int i = 0; i < 32; i ++) {
        printf("%4s: 0x%08x(%010d)%c", regs[i], gpr(i), gpr(i), i % 4 == 3? '\n': ' ');
    }
}