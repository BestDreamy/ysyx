#include "dut.h"
#include "debug.h"
#include "paddr.h"
#include "cpu.h"
#include <cstddef>
#include <dlfcn.h>

void (*ref_difftest_memcpy)(paddr_t addr, void *buf, size_t n, bool direction) = NULL;
void (*ref_difftest_regcpy)(void *dut, bool direction) = NULL;
void (*ref_difftest_exec)(uint64_t n) = NULL;

void init_difftest(const char *ref_so_file, long img_size, int port) {
    Assert(ref_so_file != NULL, "Difftest file not found!");

    void *handle = dlopen(ref_so_file, RTLD_LAZY);
    Assert(handle, "Difftest file cannot open!");

    ref_difftest_memcpy = (void (*)(paddr_t, void*, size_t, bool))dlsym(handle, "difftest_memcpy");
    Assert(ref_difftest_memcpy, "difftest_memcpy() cannot load!");

    ref_difftest_regcpy = (void (*)(void*, bool))dlsym(handle, "difftest_regcpy");
    Assert(ref_difftest_regcpy, "difftest_regcpy() cannot load!");

    ref_difftest_exec = (void (*)(uint64_t))dlsym(handle, "difftest_exec");
    Assert(ref_difftest_exec, "difftest_exec() cannot load!");

    void (*ref_difftest_init)(int) = (void (*)(int))dlsym(handle, "difftest_init");
    assert(ref_difftest_init);

    // Log("Differential testing: %s", ANSI_FMT("ON", GREEN_TXT));
    // Log("The result of every instruction will be compared with %s. "
    //     "This will help you a lot for debugging, but also significantly reduce the performance. "
    //     "If it is not necessary, you can turn it off in autoconfig.", ref_so_file);

    ref_difftest_init(port);
    // Copy the pmem(npc) to pmem(nemu)
    ref_difftest_memcpy(RESET_VECTOR, guest_to_host(RESET_VECTOR), img_size, DIFFTEST_TO_REF);
    // Copy the  reg(npc) to  reg(nemu)
    ref_difftest_regcpy(&npc_cpu, DIFFTEST_TO_REF);
}

void difftest_step(paddr_t pc, paddr_t npc) {
    Log("DiffTest Step");
    ref_difftest_exec(1);

    CPU_state ref;
    ref_difftest_regcpy(&ref, DIFFTEST_TO_DUT);
    checkregs(ref, pc);
}

bool checkregs(CPU_state ref, paddr_t pc) {
    bool ok = 1;
    for (int i = 0; i < 32; i ++) {
        if (ref.gpr[i] == npc_cpu.gpr[i]) continue;
        ok = 0;
    }
    if (ref.pc != npc_cpu.pc) ok = 0;
    return ok;
}