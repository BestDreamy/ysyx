#ifndef TRACE_H
#define TRACE_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
typedef uint8_t  uint8;
typedef uint32_t uint32;
typedef uint64_t uint64;
typedef int32_t  int32;
typedef int64_t  int64;

void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);

void itrace (uint64 pc, uint32 inst);
void itraceDisplay();

#endif