#ifndef DIFFTEST_H
#define DIFFTEST_H
#include "cpu.h"
enum { DIFFTEST_TO_DUT, DIFFTEST_TO_REF };
extern CPU_state ref;

void init_difftest(const char *ref_so_file, long img_size, int port);
void difftest_step(paddr_t pc, paddr_t npc);
bool checkregs(CPU_state ref, paddr_t pc);
void dump_gpr(CPU_state ref);
void cmp_reg();
#endif
