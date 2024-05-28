#ifndef MMIO_H
#define MMIO_H
#include "map.h"

void add_mmio_map(const char *name, paddr_t addr, void *space, uint32_t len, io_callback_t callback);

word_t mmio_read(paddr_t addr, int len);
void mmio_write(paddr_t addr, int len, word_t data);

#endif
