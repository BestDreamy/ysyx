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
#include <cpu/cpu.h>
#include <difftest-def.h>
#include <memory/paddr.h>

// npc as dut, nemu as ref
__EXPORT void difftest_memcpy(paddr_t addr, void *buf, size_t n, bool direction) {
  if (direction == DIFFTEST_TO_REF) {
    // dest(ref) <- src, n-bytes
    memcpy(guest_to_host(addr), buf, n);
  }
  else assert(0);
}

__EXPORT void difftest_regcpy(void *dut, bool direction) {
  CPU_state *cpu_dut = (CPU_state*) dut;
  if (direction == DIFFTEST_TO_REF) {
    for (int i = 0; i < ARRLEN(cpu.gpr); i ++) {
      cpu.gpr[i] = cpu_dut->gpr[i];
    }
    cpu.pc = cpu_dut->pc;

    {
      cpu.csr[mstatus] = cpu_dut->csr[mstatus];
      cpu.csr[mtvec] = cpu_dut->csr[mtvec];
      cpu.csr[mepc] = cpu_dut->csr[mepc];
      cpu.csr[mcause] = cpu_dut->csr[mcause];
    }
  }
  else {
    for (int i = 0; i < ARRLEN(cpu.gpr); i ++) {
      cpu_dut->gpr[i] = cpu.gpr[i];
    }
    cpu_dut->pc = cpu.pc;

    {
      cpu_dut->csr[mstatus] = cpu.csr[mstatus];
      cpu_dut->csr[mtvec] = cpu.csr[mtvec];
      cpu_dut->csr[mepc] = cpu.csr[mepc];
      cpu_dut->csr[mcause] = cpu.csr[mcause];
    }
  }
}

__EXPORT void difftest_exec(uint64_t n) {
  cpu_exec(n);
}

__EXPORT void difftest_raise_intr(word_t NO) {
  cpu.pc = isa_raise_intr(NO, cpu.pc);
}

__EXPORT void difftest_init(int port) {
  Log("NEMU as reference difftest init !");
  /* Perform ISA dependent initialization. */
  init_isa();
}
