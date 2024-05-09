/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <isa.h>
#include "local-include/reg.h"

const char *regs[] = {
  "zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};

void isa_reg_display() {
  printf("RV64-nemu registers:\n");
  printf("pc\t0x%lx(%ld)\n", cpu.pc, cpu.pc);
  for (int i = 0; i < ARRLEN(regs); i ++) {
    int idx = check_reg_idx(i);
    printf("%4s: 0x%08lx(%012ld)%c", regs[idx], gpr(idx), gpr(idx), i % 4 == 3? '\n': ' ');
  }
}

word_t isa_reg_str2val(const char *s, bool *success) {
  if (!(strcmp(s, "pc") && strcmp(s, "$pc") && strcmp(s, "PC") && strcmp(s, "$PC"))) {
    return cpu.pc;
  }

  word_t ans = 0;
  int i = 0;
  for (; i < ARRLEN(regs); i ++) {
    if (strcmp(s, regs[i]) == 0 || strcmp(s + 1, regs[i]) == 0) {
      ans = gpr(i);
      break;
    }
  }
  if(i == ARRLEN(regs)) *success = false;
  return ans;
}
