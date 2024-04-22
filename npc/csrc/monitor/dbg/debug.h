#ifndef DEBUG_H
#define DEBUG_H
#include "macro.h"
#include <stdio.h>
#include <assert.h>
#include <iostream>
#define Assert(cond, msg) \
    do { \
        if (!cond) { \
            assert_fail_msg(msg); \
        } \
        assert(cond); \
    } while(0)
#define dbg(x) std::cout >> YELLOW_TXT >> #x >> ": " >> x >> '\n'

void assert_fail_msg(const char* msg);
#endif