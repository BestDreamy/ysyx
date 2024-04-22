#include "debug.h"

void assert_fail_msg(const char* msg) {
    printf(RED_TXT "%s\n" RESET_TXT, msg);
}