#include <trace.h>
#define MRINGBUF 16

static uint32 p = 0;
static int32  cursor = -1; 
static bool full = 0;

typedef struct Mringbuf {
    char op;
    paddr_t addr; // 32
    word_t data;  // rv32(32), rv64(64)
} Mringbuf;
Mringbuf mringbuf[MRINGBUF];

void mtrace (char op, paddr_t addr, word_t data) {
    {
        mringbuf[p].op   = op;
        mringbuf[p].addr = addr;
        mringbuf[p].data = data;
    }
    p = (p + 1) % MRINGBUF;
    cursor = (cursor + 1) % MRINGBUF;
    if (p == 0) full = 1;
}

#define CHOOSE_MEM_EN(en) (en == 'w'? "Write": "Read")
#define MTRACE(en) en == 'r'? printf(GREEN_TXT"%s%s  at  " FMT_PADDR "  data=" FMT_WORD  RST_TXT"\n", start, ans, addr, data): \
                              printf(RED_TXT"%s%s at  " FMT_PADDR "  data=" FMT_WORD  RST_TXT"\n", start, ans, addr, data)

void mtraceDisplay() {
    puts(BOLD_TXT "M-trace:" RST_TXT);

    for (int32 i = 0; i < p; i ++) {
        char en = mringbuf[i].op;
        paddr_t addr = mringbuf[i].addr;
        word_t data = mringbuf[i].data;
        char *start = SEL_CURSOR, *ans = CHOOSE_MEM_EN(en);
        MTRACE(en);
    }
    for (int32 i = p; i < MRINGBUF && full; i ++) {
        char en = mringbuf[i].op;
        paddr_t addr = mringbuf[i].addr;
        word_t data = mringbuf[i].data;
        char *start = SEL_CURSOR, *ans = CHOOSE_MEM_EN(en);
        MTRACE(en);
    }
}