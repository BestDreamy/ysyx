#include <common.h>
#include "syscall.h"

intptr_t sys_write (int fd, const void* buf, size_t count) {
  assert(fd == 1 || fd == 2);
  for (intptr_t i = 0; i < count; i ++) {
    putch(*((char*)buf + i));
  }
  return count;
}

void do_syscall(Context *c) {
  uintptr_t a[4] = {
    c->GPR1, c->GPR2, c->GPR3, c->GPR4
  };

  // From navy-apps/libs/libos/src/syscall.c
  switch (a[0]) {
    case 0: 
      // printf("\tsyscall to SYS_exit\n"); 
      halt(c->GPRx); 
      break;
    case 1: 
      // printf("\tsyscall to SYS_yield\n"); 
      c->GPRx = 0; 
      yield(); 
      break;
    case 4: 
      // printf("\tsyscall to SYS_write\n"); 
      c->GPRx = sys_write(a[1], (void*)a[2], a[3]); 
      break;
    case 9: 
      // printf("\tsyscall to SYS_brk\n"); 
      c->GPRx = 0; 
      break;
    default: 
      panic("Unhandled syscall ID = %d", a[0]);
  }

#ifdef STRACE
  char *type = (a[0] ==         SYS_exit) ? "SYS_EXIT" :
               (a[0] ==        SYS_yield) ? "SYS_YIELD" :
               (a[0] ==         SYS_open) ? "SYS_OPEN" :
               (a[0] ==         SYS_read) ? "SYS_READ" :
               (a[0] ==        SYS_write) ? "SYS_WRITE" :
               (a[0] ==        SYS_close) ? "SYS_CLOSE" :
               (a[0] ==        SYS_lseek) ? "SYS_LSEEK" :
               (a[0] ==          SYS_brk) ? "SYS_BRK" :
               (a[0] ==       SYS_execve) ? "SYS_EXECVE" :
               (a[0] == SYS_gettimeofday) ? "SYS_GETTIMEOFDAY" : "";
  // char *file = ((a[0] !=         SYS_exit) &&
  //               (a[0] !=        SYS_yield) &&
  //               (a[0] !=         SYS_open) &&
  //               (a[0] !=          SYS_brk) &&
  //               (a[0] != SYS_gettimeofday)) ? fs_get(a[1]).name : "none";
  // printf("[strace] file: %s, type: %s, a1 = %x, a2 = %x, a3 = %x, ret: %x\n", file, type, a[1], a[2], a[3], c->GPRx);
  printf("\033[1;33m(strace) type=%s, arg1=%x, arg2=%x, arg3=%x, ret=%x\n\033[0m", type, a[1], a[2], a[3], c->GPRx);
#endif
}
