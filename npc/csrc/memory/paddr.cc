#include "paddr.h"
#include "debug.h"
#include "host.h"
#include "mmio.h"

uint8_t* guest_to_host(paddr_t addr) { return pmem + addr - CONFIG_MBASE; }
paddr_t  host_to_guest(uint8_t* mem) { return  mem - pmem + CONFIG_MBASE; }

bool in_pmem(paddr_t addr) {
    return addr >= PMEM_LEFT && addr < PMEM_RIGHT;
}

void out_of_bound(paddr_t addr) {
    printf(" --> paddr in %x", addr);
    Assert(0, " is out of bounds memory accsee!\n");
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