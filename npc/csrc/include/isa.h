#ifndef ISA_H
#define ISA_H
#include "macro.h"

// IFDEF  CONFIG_ISA32 -> 32
// IFNDEF CONFIG_ISA32 -> 64
#define CONFIG_ISA32 1
typedef MUXDEF(CONFIG_ISA32, uint32_t, uint64_t) word_t;
typedef MUXDEF(CONFIG_ISA32, int32_t, int64_t)  sword_t;
#define FMT_WORD MUXDEF(CONFIG_ISA32, "0x%0" PRIx32, "0x%016" PRIx64)

#endif