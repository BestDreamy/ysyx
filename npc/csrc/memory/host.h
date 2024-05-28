#ifndef __HOST_H__
#define __HOST_H__
#include "isa.h"

static inline word_t host_read(void *addr, int len) {
    switch (len) {
        case 1: return *(uint8_t*) addr;
        case 2: return *(uint16_t*)addr;
        case 4: return *(uint32_t*)addr;
        IFDEF(CONFIG_ISA64, case 8: return *(uint64_t*)addr;);
        default: Assert(0, "Incorrect memory access size!\n");
    }
}

static inline void host_write(void *addr, int len, word_t data) {
    switch (len) {
        case 1: *(uint8_t*) addr = data; break;
        case 2: *(uint16_t*)addr = data; break;
        case 4: *(uint32_t*)addr = data; break;
        IFDEF(CONFIG_ISA64, case 8: *(uint64_t*)addr = data; break;);
        default: Assert(0, "Incorrect memory access size!\n");
    }
}

#endif