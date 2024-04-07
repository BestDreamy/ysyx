#include <trace.h>
#define IRINGBUF 32

typedef struct Iringbuf {
    uint32 inst;
}Iringbuf;
Iringbuf iringbuf[IRINGBUF];

uint32 p = 0;
bool full = 0;

void itrace (uint32 inst) {
    {
        iringbuf[p].inst = inst;
    }
    p = (p + 1) % IRINGBUF;
    if (p == 0) full = 1;
}

void itraceDisplay() {
    for (uint32 i = 0; i < p; i ++) {
        printf("%08x\n", iringbuf[i].inst);
    }
    for (uint32 i = p; i < IRINGBUF && full; i ++) {
        printf("%08x\n", iringbuf[i].inst);
    }
}