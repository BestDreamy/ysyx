#include "macro.h"
#include "stdio.h"

extern "C" bool ebreak(uint32 inst) {
    if (inst == 0x100073) puts("******************* ebreak triggered !!!");
    return (inst == 0x100073);
}
