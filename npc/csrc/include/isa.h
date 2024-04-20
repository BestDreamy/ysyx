#ifndef ISA_H
#define ISA_H
#include "macro.h"

#define CONFIG_ISA32 1
typedef MUXDEF(CONFIG_ISA64, uint64_t, uint32_t) word_t;
typedef MUXDEF(CONFIG_ISA64, int64_t, int32_t)  sword_t;
#define FMT_WORD MUXDEF(CONFIG_ISA64, "0x%016" PRIx64, "0x%08" PRIx32)

typedef MUXDEF(CONFIG_ISA64, uint64_t, uint32_t) paddr_t;
#define FMT_PADDR MUXDEF(CONFIG_ISA64, "0x%016" PRIx64, "0x%08" PRIx32)

typedef word_t word;
typedef sword_t sword;
typedef paddr_t paddr;
#endif