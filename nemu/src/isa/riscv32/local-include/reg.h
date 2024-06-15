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

#ifndef __RISCV32_REG_H__
#define __RISCV32_REG_H__

#include <common.h>
#include <isa.h>

static inline int check_reg_idx(int idx) {
  IFDEF(CONFIG_RT_CHECK, assert(idx >= 0 && idx < 32));
  return idx;
}

// static inline int check_csr_idx(word_t idx) {
//   int csrs[4] = {
//     0x300,
//     0x305,
//     0x341, 
//     0x342
//   };
//   bool ok = 0;
//   for (int i = 0; i < ARRLEN(csrc); i ++) {
//     if (csrs[i] == idx) ok = 1;
//   }
//   IDDEF(CONFIG_RT_CHECK, assert(! ok));
//   return idx;
// }

#define gpr(idx) cpu.gpr[check_reg_idx(idx)]
#define csr(imm) cpu.csr[csr2idx(imm)]

static inline const char* reg_name(int idx, int width) {
  extern const char* regs[];
  return regs[check_reg_idx(idx)];
}

static inline int csr2idx(word_t imm) {
  switch (imm) {
    case 0x342: return mcause;
    case 0x341: return mepc;
    case 0x300: return mstatus;
    case 0x305: return mtvec;
    default: panic("UNKNOWN CSR");
  }
}

#endif
