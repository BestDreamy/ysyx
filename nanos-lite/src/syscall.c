#include <common.h>
#include "syscall.h"
void do_syscall(Context *c) {
  uintptr_t a[4];
  a[0] = c->GPR1;

  // From navy-apps/libs/libos/src/syscall.c
  switch (a[0]) {
    case 1: printf("syscall() to SYS_yield\n"); yield(); break;
    default: panic("Unhandled syscall ID = %d", a[0]);
  }
}
