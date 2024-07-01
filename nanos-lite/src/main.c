#include <common.h>

void init_mm(void);
void init_device(void);
void init_ramdisk(void);
void init_irq(void);
void init_fs(void);
void init_proc(void);

/*

main() --> init_irq()         yield()                                 do_event()*
                    |         ^      |                                ^
               [AM] |         |      |                                |
                    v         |      v                                |
                    cte_init()       ecall*             __am_irq_handle()*
                                          |             ^
                                   [nemu] |             |
                                          v             |
                                          __am_asm_trap()

*ecall modify the mcause by isa_raise_intr()
*__am_irq_handle() deal with the event by mcause
*do_event() deal with the GPR1 by event and GPR1 is defined in init_proc()

*/

int main() {
  extern const char logo[];
  printf("%s", logo);
  Log("'Hello World!' from Nanos-lite");
  Log("Build time: %s, %s", __TIME__, __DATE__);

  init_mm();

  init_device();

  init_ramdisk();

#ifdef HAS_CTE
  init_irq();
#endif

  init_fs();

  init_proc();
  
  Log("Finish initialization");

#ifdef HAS_CTE
  yield();
#endif

  panic("Should not reach here");
}
