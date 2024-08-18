#include <am.h>
#include <riscv/riscv.h>
#include <klib.h>

static Context* (*user_handler)(Event, Context*) = NULL;

Context* __am_irq_handle(Context *c) {
  if (user_handler) {
    Event ev = {0};
    switch(c->mcause) {
      case 0xb:
        // printf("GPR1=%d when do event --> ", c->GPR1);
        if (c->GPR1 == -1) 
          ev.event = EVENT_YIELD;
        else  
          ev.event = EVENT_SYSCALL;
        break;
      default: ev.event = EVENT_ERROR; break;
    }
    c = user_handler(ev, c);
    assert(c != NULL);
  }

  return c;
}

extern void __am_asm_trap(void);

bool cte_init(Context*(*handler)(Event, Context*)) {
  // initialize exception entry
  asm volatile("csrw mtvec, %0" : : "r"(__am_asm_trap));

  // register event handler
  user_handler = handler;

  return true;
}

Context *kcontext(Area kstack, void (*entry)(void *), void *arg) {
  Context* c = (Context*)kstack.end - 1;
  c->mepc = (uintptr_t)entry; // wait for mret
  c->GPR2 = (uintptr_t)arg;
  c->mstatus = 0x1800;
  return c;
}

void yield() {
#ifdef __riscv_e
  asm volatile("li a5, -1; ecall");
#else
  asm volatile("li a7, -1; ecall");
#endif
}

bool ienabled() {
  return false;
}

void iset(bool enable) {
}
