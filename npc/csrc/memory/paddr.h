#ifndef PADDR_H
#define PADDR_H

#define CONFIG_MBASE 0x80000000
#define CONFIG_MSIZE 0x8000000
#define CONFIG_PC_RESET_OFFSET 0x0

#define PMEM_LEFT  ((paddr_t)CONFIG_MBASE)
#define PMEM_RIGHT ((paddr_t)CONFIG_MBASE + CONFIG_MSIZE)
#define RESET_VECTOR (PMEM_LEFT + CONFIG_PC_RESET_OFFSET)

typedef MUXDEF(CONFIG_ISA32, uint32_t, uint64_t) paddr_t;
#define FMT_PADDR MUXDEF(CONFIG_ISA32, "0x%08" PRIx32, "0x%016" PRIx64)

bool in_pmem(paddr_t addr);
bool out_of_bound(paddr_t addr);

word_t paddr_read(paddr_t addr, int len);
void  paddr_write(paddr_t addr, int len, word_t data);
#endif