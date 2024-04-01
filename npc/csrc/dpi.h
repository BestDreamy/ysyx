#include "macro.h"
#include "stdio.h"

extern "C" void ebreak(int inst) {
    // (0x100073)
    if (inst == 0) puts("*********************ebreak************************");
}
