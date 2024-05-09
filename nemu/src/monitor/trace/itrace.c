#include <trace.h>
#define IRINGBUF 32

static uint32 p = 0;
static int32  cursor = -1; 
static bool full = 0;

typedef struct Iringbuf {
    uint64 pc;
    uint32 inst;
} Iringbuf;
Iringbuf iringbuf[IRINGBUF];

void itrace (uint64 pc, uint32 inst) {
    {
        iringbuf[p].pc   = pc;
        iringbuf[p].inst = inst;
    }
    p = (p + 1) % IRINGBUF;
    cursor = (cursor + 1) % IRINGBUF;
    if (p == 0) full = 1;

    void isa_reg_display();
    // isa_reg_display();
}

#define SCALE_STR(a, b) ({ for (int i = strlen(a); i < b; i ++) a[i] = ' '; a[b] = '\0'; a; })
void itraceDisplay() {
    puts(BOLD_TXT "I-trace:" RST_TXT);

    for (int32 i = 0; i < p; i ++) {
        char *start = SEL_CURSOR, disas[32];
        disassemble(disas, 32, iringbuf[i].pc, (uint8*)&iringbuf[i].inst, 4);
        printf("%s0x%08lx: %s\t%08x\n", start, iringbuf[i].pc, SCALE_STR(disas, 27), iringbuf[i].inst);
    }
    for (int32 i = p; i < IRINGBUF && full; i ++) {
        char *start = SEL_CURSOR, disas[32];
        disassemble(disas, 32, iringbuf[i].pc, (uint8*)&iringbuf[i].inst, 4);
        printf("%s0x%08lx: %s\t%08x\n", start, iringbuf[i].pc, SCALE_STR(disas, 27), iringbuf[i].inst);
    }
}