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

void itrace (paddr_t pc, uint32_t inst);
void itraceDisplay();

// #define CONFIG_MTRACE 1
void mtrace(char op, paddr_t addr, word_t data);
void mtraceDisplay();
#endif