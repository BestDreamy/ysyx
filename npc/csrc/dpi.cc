#include "dpic.h"
#include <stdio.h>

extern "C" bool halt(uint32_t inst) {
    if (inst == 0x100073) puts("******************* ebreak triggered !!!");
    return (inst == 0x100073);
}

extern "C" uint32_t fetch(paddr_t pc) {
    
}
