#include "difftest.h"
#include "debug.h"
#include "paddr.h"
#include <cstddef>
#include <dlfcn.h>

void (*ref_difftest_memcpy)(paddr_t addr, void *buf, size_t n, bool direction) = NULL;
void (*ref_difftest_regcpy)(void *dut, bool direction) = NULL;
void (*ref_difftest_exec)(uint64_t n) = NULL;

void init_difftest(const char *ref_so_file) {
    Assert(ref_so_file != NULL, "Difftest file not found!");

    void *handle = dlopen(ref_so_file, RTLD_LAZY);
    Assert(handle, "Difftest file cannot open!");

    ref_difftest_memcpy = (void (*)(paddr_t, void*, size_t, bool))dlsym(handle, "difftest_memcpy");
    Assert(ref_difftest_memcpy, "difftest_memcpy() cannot load!");

    ref_difftest_regcpy = (void (*)(void*, bool))dlsym(handle, "difftest_regcpy");
    Assert(ref_difftest_regcpy, "difftest_regcpy() cannot load!");

    ref_difftest_exec = (void (*)(uint64_t))dlsym(handle, "difftest_exec");
    Assert(ref_difftest_exec, "difftest_exec() cannot load!");
}
