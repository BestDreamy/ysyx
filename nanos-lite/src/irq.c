#include <common.h>

static Context* do_event(Event e, Context* c) {
  switch (e.event) {
    case EVENT_YIELD: printf("Event yield is triggered\n"); break;
    case EVENT_SYSCALL: printf("Event syscall is triggered\n****"); break;
    default: panic("Unhandled event ID = %d", e.event);
  }

  return c;
}

void init_irq(void) {
  Log("Initializing interrupt/exception handler...");
  cte_init(do_event);
}
