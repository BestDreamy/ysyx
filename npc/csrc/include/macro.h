#ifndef MACRO_H
#define MACRO_H
#include "autoconfig.h"
#include <stdint.h>
#include <inttypes.h>

typedef uint32_t uint32;
typedef int32_t  int32;

#define concat(x, y) x ## y

// See https://stackoverflow.com/questions/26099745/test-if-preprocessor-symbol-is-defined-inside-macro
#define CHOOSE2nd(a, b, ...) b
#define MUX_WITH_COMMA(contain_comma, a, b) CHOOSE2nd(contain_comma a, b)
#define MUX_MACRO_PROPERTY(p, macro, a, b) MUX_WITH_COMMA(concat(p, macro), a, b)
// define placeholders for some property
#define __P_DEF_0  X,
#define __P_DEF_1  X,
// define some selection functions based on the properties of BOOLEAN macro
#define MUXDEF(macro, X, Y)  MUX_MACRO_PROPERTY(__P_DEF_, macro, X, Y)
#define MUXNDEF(macro, X, Y) MUX_MACRO_PROPERTY(__P_DEF_, macro, Y, X)

// simplification for conditional compilation
#define __IGNORE(...)
#define __KEEP(...) __VA_ARGS__
// keep the code if a boolean macro is defined
#define IFDEF(macro, ...) MUXDEF(macro, __KEEP, __IGNORE)(__VA_ARGS__)
// keep the code if a boolean macro is undefined
#define IFNDEF(macro, ...) MUXNDEF(macro, __KEEP, __IGNORE)(__VA_ARGS__)

#define RESET_TXT       "\033[0m"
#define BOLD_TXT        "\033[1m"
#define BLACK_TXT       "\033[30m"
#define RED_TXT         "\033[1;31m"
#define GREEN_TXT       "\033[1;32m"
#define YELLOW_TXT      "\033[33m"
#define BLUE_TXT        "\033[34m"
#define MAGENTA_TXT     "\33[1;35m"
#define CYAN_TXT        "\33[1;36m"
#define WHITE_TXT       "\33[1;37m"
#define UNDERLINE_TXT   "\033[4m"

#define ANSI_FMT(str, fmt) fmt str RESET_TXT
#endif
