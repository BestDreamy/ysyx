#ifndef TRACE_H
#define TRACE_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <memory/paddr.h>
typedef uint8_t  uint8;
typedef uint32_t uint32;
typedef uint64_t uint64;
typedef int32_t  int32;
typedef int64_t  int64;
#define GREEN_TXT "\033[32m"
#define RED_TXT "\033[33m"
#define BLUE_TXT  "\033[34m"
#define RST_TXT   "\033[0m"
#define BOLD_TXT  "\033[1m"

void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);

void itrace (uint64 pc, uint32 inst);
void itraceDisplay();


#define CONFIG_MTRACE 1
void mtrace(char en, uint32 addr, uint64 data);

#define CONFIG_FTRACE 1
void ftrace_call();
void ftrace_ret();

#endif