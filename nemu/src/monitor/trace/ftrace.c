#include <trace.h>

void init_elf() {
    ;
}

bool isSymbolFunc() {
    return true;
}

void ftrace_call() {
    
    IFDEF(CONFIG_FTRACE, printf("call\n"));
}

void ftrace_ret() {
    IFDEF(CONFIG_FTRACE, printf("ret\n"));
}