#include <trace.h>
#define IRINGBUF 32

static uint32_t p = 0;
static int32_t  cursor = -1; 
static bool full = 0;

typedef struct Iringbuf {
    paddr_t pc;
    uint32_t inst;
} Iringbuf;
Iringbuf iringbuf[IRINGBUF];

void itrace (paddr_t pc, uint32_t inst) {
    {
        iringbuf[p].pc   = pc;
        iringbuf[p].inst = inst;
    }
    p = (p + 1) % IRINGBUF;
    cursor = (cursor + 1) % IRINGBUF;
    if (p == 0) full = 1;
}

#define SCALE_STR(a, b) ({ for (int i = strlen(a); i < b; i ++) a[i] = ' '; a[b] = '\0'; a; })
void itraceDisplay() {
    puts(BOLD_TXT "I-trace:" RESET_TXT);
    char disas[32];
    for (int32_t i = 0; i < p; i ++) {
        const char *start = SEL_CURSOR;
        disassemble(disas, sizeof(disas), iringbuf[i].pc, (uint8_t*)&iringbuf[i].inst, 4);
        printf("%s" FMT_PADDR ": %s\t%08x\n", start, iringbuf[i].pc, SCALE_STR(disas, 27), iringbuf[i].inst);
    }
    for (int32_t i = p; i < IRINGBUF && full; i ++) {
        const char *start = SEL_CURSOR;
        disassemble(disas, sizeof(disas), iringbuf[i].pc, (uint8_t*)&iringbuf[i].inst, 4);
        printf("%s" FMT_PADDR ": %s\t%08x\n", start, iringbuf[i].pc, SCALE_STR(disas, 27), iringbuf[i].inst);
    }
}