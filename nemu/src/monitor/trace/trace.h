#ifndef TRACE_H
#define TRACE_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <memory/paddr.h> // mtrace
#include <elf.h> // ftrace
typedef uint8_t  uint8;
typedef uint32_t uint32;
typedef uint64_t uint64;
typedef int32_t  int32;
typedef int64_t  int64;
#define SEL_CURSOR (cursor == i? "   --->  ": " \t ")
#define BLACK_TXT "\033[30m"
#define RED_TXT  "\033[31m"
#define GREEN_TXT "\033[32m"
#define YELLOW_TXT "\033[33m"
#define BLUE_TXT  "\033[34m"
#define RST_TXT   "\033[0m"
#define BOLD_TXT  "\033[1m"
#define UNDERLINE_TXT "\033[4m"

void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);

void itrace (uint64 pc, uint32 inst);
void itraceDisplay();

void mtrace(char op, paddr_t addr, word_t data);
void mtraceDisplay();

void init_elf(const char *file);
void ftrace_call(uint64 pc, uint64 npc);
void ftrace_ret(uint64 pc, uint64 npc);
void ftraceDisplay();

#endif
