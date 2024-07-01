#include <common.h>
#include "syscall.h"
void do_syscall(Context *c) {
  uintptr_t a[4] = {
    c->GPR1, c->GPR2, c->GPR3, c->GPR4
  };
  // printf("gpr1=%d\tgpr2=%d\tgpr3=%d\tgpr4=%d\n", a[0], a[1], a[2], a[3]);

  // From navy-apps/libs/libos/src/syscall.c
  switch (a[0]) {
    case 0: printf("\tsyscall to SYS_exit\n"); halt(c->GPRx); break;
    case 1: printf("\tsyscall to SYS_yield\n"); yield(); break;
    case 4: printf("\tsyscall to SYS_write\n"); break;
    default: 
      panic("Unhandled syscall ID = %d", a[0]);
  }
}
