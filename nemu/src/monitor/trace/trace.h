#ifndef TRACE_H
#define TRACE_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
typedef uint32_t uint32;

void itrace (uint32 inst);
void itraceDisplay();

#endif