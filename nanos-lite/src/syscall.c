#include <common.h>
#include "syscall.h"
#include "fs.h"

intptr_t sys_write (int fd, const void* buf, size_t len) {
  assert(fd == 1 || fd == 2);
  for (intptr_t i = 0; i < len; i ++) {
    putch(*((char*)buf + i));
  }
  return len;
}

void do_syscall(Context *c) {
  uintptr_t a[4] = {
    c->GPR1, c->GPR2, c->GPR3, c->GPR4
  };

  // From navy-apps/libs/libos/src/syscall.c
  switch (a[0]) {
    case SYS_exit: 
      // printf("\tsyscall to SYS_exit\n"); 
      halt(c->GPRx);
      break;
    case SYS_yield: 
      // printf("\tsyscall to SYS_yield\n"); 
      c->GPRx = 0;
      yield();
      break;
    case SYS_open:
      c->GPRx = fs_open((char*)a[1], a[2], a[3]); 
      break;
    case SYS_read:
      c->GPRx = fs_read(a[1], (void*)a[2], a[3]); 
      break;
    case SYS_write:
      // printf("\tsyscall to SYS_write\n"); 
      /* c->GPRx = sys_write(a[1], (void*)a[2], a[3]);  */
      c->GPRx = fs_write(a[1], (void*)a[2], a[3]); 
      break;
    case SYS_close:
      c->GPRx = fs_close(a[1]); 
      break;
    case SYS_lseek:
      c->GPRx = fs_lseek(a[1], a[2], a[3]); 
      break;
    case SYS_brk:
      // printf("\tsyscall to SYS_brk\n"); 
      c->GPRx = 0; 
      break;
    default:
      panic("Unhandled syscall ID = %d", a[0]);
  }

// #define STRACE 1
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
  printf("\033[1;33m(strace) type=%s, arg1=%x, arg2=%x, arg3=%x, ret=%x\n\033[0m", type, a[1], a[2], a[3], c->GPRx);
#endif
}
