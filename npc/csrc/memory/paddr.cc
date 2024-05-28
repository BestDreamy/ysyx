#include "paddr.h"
#include "debug.h"
#include "host.h"

uint8_t* guest_to_host(paddr_t addr) { return pmem + addr - CONFIG_MBASE; }
paddr_t  host_to_guest(uint8_t* mem) { return  mem - pmem + CONFIG_MBASE; }

bool in_pmem(paddr_t addr) {
    return addr >= PMEM_LEFT && addr < PMEM_RIGHT;
}

void out_of_bound(paddr_t addr) {
    Assert(0, "Out of bounds memory accsee!\n");
}

static word_t pmem_read(paddr_t addr, int len) {
    word_t ret = host_read(guest_to_host(addr), len);
    return ret;
}

static void pmem_write(paddr_t addr, int len, word_t data) {
    host_write(guest_to_host(addr), len, data);
}

word_t paddr_read(paddr_t addr, int len) {
    if (in_pmem(addr)) return pmem_read(addr, len);
    IFDEF(CONFIG_DEVICE, return mmio_read(addr, len));
    return out_of_bound(addr), 0;
}

void paddr_write(paddr_t addr, int len, word_t data) {
    if (in_pmem(addr)) return pmem_write(addr, len, data);
    IFDEF(CONFIG_DEVICE, return mmio_write(addr, len, data));
    out_of_bound(addr);
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