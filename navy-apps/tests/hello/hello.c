#include <unistd.h>
#include <stdio.h>

int main() {
  /*

  write() --> libc/src/syscalls/syswrite.c --> libc/src/reent/writer.c --> libos/src/syscall.c
  main() --> wirte() --> _write_r() --> _write()

  */
  write(1, "Hello World!\n", 13);
  int i = 2;
  volatile int j = 0;
  while (1) {
    j ++;
    if (j == 10000) {
      printf("Hello World from Navy-apps for the %dth time!\n", i ++);
      j = 0;
    }
  }
  return 0;
}

/*
int main() {
  write(1, "Hello World!\n", 13);
  int i = 4;
  volatile int j = 0;
  while (i) {
    j ++;
    if (j == 1000000) {
      printf("Hello World from Navy-apps for the %dth time!\n", i --);
      j = 0;
    }
  }
  return 0;
}
*/