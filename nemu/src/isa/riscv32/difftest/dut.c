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
#include <cpu/difftest.h>
#include "../local-include/reg.h"

// nemu as dut, spike as ref
bool isa_difftest_checkregs(CPU_state *ref_r, vaddr_t pc) {
  for (int i = 0; i < ARRLEN(cpu.gpr); i ++) {
    if (cpu.gpr[i] == ref_r->gpr[i]) continue;
    printf("gpr in %s: 0x%08x != 0x%08x\n", regs[i], cpu.gpr[i], ref_r->gpr[i]);
    return false;
  }

  if (cpu.pc != ref_r->pc) {
    printf("pc: 0x%08x != 0x%08x\n", cpu.pc, ref_r->pc);
    return false;
  }

  int csr_addr[] = {0x300, 0x305, 0x341, 0x342};
  for (int i = 0; i < ARRLEN(csr_addr); i ++) {
    if (cpu.csr[i] == ref_r->csr[i]) continue;
    printf("csr in %s: 0x%08x != 0x%08x\n", csrs[i], cpu.csr[i], ref_r->csr[i]);
    return false;
  }
  return true;
}

void isa_difftest_attach() {
}
