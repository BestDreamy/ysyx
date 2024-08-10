#include <am.h>
#include <klib-macros.h>
#include <klib.h>

#define STACK_SIZE (4096 * 8) // 8K
typedef union {
  uint8_t stack[STACK_SIZE];
  struct { Context *cp; };
} PCB;
static PCB pcb[2], pcb_boot, *current = &pcb_boot;

// void dbg() {
//   uint32_t sp, pc;
//   asm volatile ("auipc %0, 0\n": "=r"(pc));
//   printf("PC: %x\n", pc);
//   __asm__ volatile ("mv %0, sp": "=r" (sp));
//   printf("SP: %x\n", sp);
// }

static void f(void *arg) {
  while (1) {
    putch("?AB"[(uintptr_t)arg > 2 ? 0 : (uintptr_t)arg]);
    // if ((uintptr_t)arg == 1) putch('A');
    // else if ((uintptr_t)arg == 2) putch('B');
    // else putch('?');
    for (int volatile i = 0; i < 1000000; i++) ;
    yield();
  }
}

static Context *schedule(Event ev, Context *prev) {
  current->cp = prev;
  current = (current == &pcb[0] ? &pcb[1] : &pcb[0]);
  return current->cp;
}

// boot --> pcb0 -> 'A' --> pcb1 -> 'B' --> pcb0 -> 'A' ..
int main() {
  cte_init(schedule);
  pcb[0].cp = kcontext((Area) { pcb[0].stack, &pcb[0] + 1 }, f, (void *)1L);
  pcb[1].cp = kcontext((Area) { pcb[1].stack, &pcb[1] + 1 }, f, (void *)2L);
  /* printf("A: %x\n", pcb[0].cp->mepc); */
  /* printf("B: %x\n", pcb[1].cp->mepc); */
  yield();
  panic("Should not reach here!");
}
