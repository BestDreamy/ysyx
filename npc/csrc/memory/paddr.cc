#include "paddr.h"
#include "debug.h"

uint8_t* guest_to_host(paddr_t addr) { return pmem + addr - CONFIG_MBASE; }
paddr_t  host_to_guest(uint8_t* mem) { return  mem - pmem + CONFIG_MBASE; }

bool in_pmem(paddr_t addr) {
    return addr >= PMEM_LEFT && addr < PMEM_RIGHT;
}

bool out_of_bound(paddr_t addr) {
    return !in_pmem(addr);
}

word_t pmem_read(void* addr, int len) {
    switch (len) {
        case 1: return *(uint8_t*) addr;
        case 2: return *(uint16_t*)addr;
        case 4: return *(uint32_t*)addr;
        IFDEF(CONFIG_ISA64, case 8: return *(uint64_t*)addr);
        default: Assert(0, "Incorrect memory access size!\n");
    }
}

void pmem_write(void *addr, int len, word_t data) {
    switch (len) {
        case 1: *(uint8_t*) addr = data; break;
        case 2: *(uint16_t*)addr = data; break;
        case 4: *(uint32_t*)addr = data; break;
        IFDEF(CONFIG_ISA64, case 8: *(uint64_t*)addr = data; break;);
        default: Assert(0, "Incorrect memory access size!\n");
    }
}

word_t paddr_read(paddr_t addr, int len) {
    Assert(in_pmem(addr), "Out of bounds memory accsee!\n");
    word_t data = pmem_read(guest_to_host(addr), len);
    return data;
}

void paddr_write(paddr_t addr, int len, word_t data) {
    Assert(in_pmem(addr), "Out of bounds memory accsee!\n");
    pmem_write(guest_to_host(addr), len, data);
}

void init_pmem() {
    pmem[0] = 0x13;
    pmem[1] = 0x4;
    pmem[2] = 0x0;
    pmem[3] = 0x0;

    pmem[4] = 0x17;
    pmem[5] = 0x91;
    pmem[6] = 0x0;
    pmem[7] = 0x0;

    pmem[8] = 0x13;
    pmem[9] = 0x1;
    pmem[10] = 0xc1;
    pmem[11] = 0xff;

    pmem[12] = 0xef;
    pmem[13] = 0x0;
    pmem[14] = 0xc0;
    pmem[15] = 0x0;
}