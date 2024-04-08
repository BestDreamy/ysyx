#include <trace.h>

#define CHOOSE_MEM_EN(en) (en == 'w'? "Write": "Read")
#define MTRACE(en) en == 'r'? printf(GREEN_TXT" \t %s  at  " FMT_PADDR "  data=" FMT_WORD RST_TXT"\n", ans, addr, data): \
                              printf(RED_TXT" \t %s at  " FMT_PADDR "  data=" FMT_WORD RST_TXT"\n", ans, addr, data)

void mtrace(char en, uint32 addr, uint64 data) {
    char *ans = CHOOSE_MEM_EN(en);
    MTRACE(en);
}