#include "paddr.h"

bool in_pmem(paddr_t addr) {
    return addr >= PMEM_LEFT && addr < PMEM_RIGHT;
}

bool out_of_bound(paddr_t addr) {
    return !in_pmem(addr);
}