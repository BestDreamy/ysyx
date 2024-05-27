#ifndef DEBUG_H
#define DEBUG_H
#include "macro.h"
#include <assert.h>
#include <iostream>
#define Assert(cond, msg) \
    do { \
        if (!(cond)) { \
            assert_fail_msg(msg); \
        } \
        assert(cond); \
    } while(0)

#define dbg(x) std::cout << YELLOW_TXT << #x << ": " << x << '\n' << RESET_TXT

#define Log(format, ...) \
    do { \
        printf(ANSI_FMT("[%s:%d %s] " format, BLUE_TXT) "\n", \
        __FILE__, __LINE__, __func__, ## __VA_ARGS__); \
    } while(0)

void assert_fail_msg(const char* msg);
#define panic(format, ...) Assert(0, format)
#endif
