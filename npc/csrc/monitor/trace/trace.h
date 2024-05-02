#ifndef TRACE_H
#define TRACE_H
#include "macro.h"
#include "isa.h"
#include "paddr.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#define SEL_CURSOR (cursor == i? "   --->  ": " \t ")

extern "C" void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
void itrace (paddr_t pc, uint32_t inst);
void itraceDisplay();

void mtrace(char op, paddr_t addr, word_t data);
void mtraceDisplay();
#endif