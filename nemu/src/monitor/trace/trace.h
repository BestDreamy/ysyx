#ifndef TRACE_H
#define TRACE_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
typedef uint32_t uint32;
typedef uint64_t uint64;

void itrace (uint64 pc, uint32 inst);
void itraceDisplay();

#endif