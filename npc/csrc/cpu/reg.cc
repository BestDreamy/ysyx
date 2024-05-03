#include "reg.h"
#include "macro.h"
#include "cpu.h"
#include <stdio.h>
#define gpr(i) npc_cpu.gpr[i]

void isa_reg_display() {
  printf(BOLD_TXT "Registers:\n" RESET_TXT);
  printf("pc\t0x%x(%d)\n", npc_cpu.pc, npc_cpu.pc);
  for (int i = 0; i < 32; i ++) {
    printf("%4s: 0x%08x(%010d)%c", regs[i], gpr(i), gpr(i), i % 4 == 3? '\n': ' ');
  }
}