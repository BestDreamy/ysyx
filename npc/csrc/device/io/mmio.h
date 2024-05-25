#ifndef MMIO_H
#define MMIO_H
#include "paddr.h"

word_t mmio_read(paddr_t addr, int len);
void mmio_write(paddr_t addr, int len, word_t data);

#endif
