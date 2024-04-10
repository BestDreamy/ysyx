#include <trace.h>

void init_elf(const char *file) {
    printf("%s\n", file);
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

void ftraceDisplay() {
    ;
}