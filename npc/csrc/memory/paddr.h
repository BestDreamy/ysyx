#ifndef PADDR_H
#define PADDR_H
#include "macro.h"
#include "isa.h"
#define PMEM_LEFT  ((paddr_t)CONFIG_MBASE)
#define PMEM_RIGHT ((paddr_t)CONFIG_MBASE + CONFIG_MSIZE)
#define RESET_VECTOR (PMEM_LEFT + CONFIG_PC_RESET_OFFSET)

typedef MUXDEF(CONFIG_ISA32, uint32_t, uint64_t) paddr_t;
#define FMT_PADDR MUXDEF(CONFIG_ISA32, "0x%08" PRIx32, "0x%016" PRIx64)

// Convert the address of 0x8000_0000 to pmem[]
// pmem[] as host memory
static uint8_t pmem[CONFIG_MSIZE] __attribute((aligned(4096))) = {};
uint8_t* guest_to_host(paddr_t addr);
paddr_t  host_to_guest(uint8_t* mem);

bool in_pmem(paddr_t addr);
void out_of_bound(paddr_t addr);

word_t paddr_read(paddr_t addr, int len);
void  paddr_write(paddr_t addr, int len, word_t data);

#endif