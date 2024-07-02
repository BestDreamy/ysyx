#include <common.h>
#include "syscall.h"

intptr_t sys_write (int fd, const void* buf, size_t count) {
  assert(fd == 1 || fd == 2);
  for (intptr_t i = 0; i < count; i ++) {
    putch(((char*)buf)[i]);
  }
  return count;
}

void do_syscall(Context *c) {
  uintptr_t a[4] = {
    c->GPR1, c->GPR2, c->GPR3, c->GPR4
  };
  // printf("gpr1=%d\tgpr2=%d\tgpr3=%d\tgpr4=%d\n", a[0], a[1], a[2], a[3]);

  // From navy-apps/libs/libos/src/syscall.c
  switch (a[0]) {
    case 0: printf("\tsyscall to SYS_exit\n"); halt(c->GPRx); break;
    case 1: printf("\tsyscall to SYS_yield\n"); c->GPRx = 0; yield(); break;
    case 4: printf("\tsyscall to SYS_write\n"); c->GPRx = sys_write(a[1], (void*)a[2], a[3]); break;
    default: 
      panic("Unhandled syscall ID = %d", a[0]);
  }
}
