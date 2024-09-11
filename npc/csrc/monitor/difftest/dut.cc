#include "dut.h"
#include "debug.h"
#include "paddr.h"
#include "cpu.h"
#include "sdb.h"
#include "reg.h"
#include <cstddef>
#include <dlfcn.h>

void (*ref_difftest_memcpy)(paddr_t addr, void *buf, size_t n, bool direction) = NULL;
void (*ref_difftest_regcpy)(void *dut, bool direction) = NULL;
void (*ref_difftest_exec)(uint64_t n) = NULL;
CPU_state ref;

static bool is_skip_ref = false;

void difftest_skip_ref() {
    is_skip_ref = true;
}

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
    if (is_skip_ref == 0) {
        ref_difftest_exec(1);
    } else {
        ref_difftest_regcpy(&npc_cpu, DIFFTEST_TO_REF);
        is_skip_ref = false;
    }

    ref_difftest_regcpy(&ref, DIFFTEST_TO_DUT);

    if(checkregs(ref, pc) == 0) {
        npc_state.state = NPC_ABORT;
        npc_state.halt_pc = pc;
    }
}

#define dump(s, x, y) printf("%4s -->", s); \
                      printf(" npc: 0x%08x(%010d) !=", x, x); \
                      printf(" nemu: 0x%08x(%010d)\n", y, y);

bool checkregs(CPU_state ref, paddr_t pc) {
    bool ok = 1;
    for (int i = 0; i < 32; i ++) {
        if (ref.gpr[i] == npc_cpu.gpr[i]) continue;
        isa_reg_display(npc_cpu);
        isa_reg_display(ref);
        ok = 0;
    }

    if (ref.pc != npc_cpu.pc) {
        dump("PC", npc_cpu.pc, ref.pc);
        ok = 0;
    }

    if (ref.mstatus != npc_cpu.mstatus) {
        dump("mstatus", npc_cpu.mstatus, ref.mstatus);
        ok = 0;
    }
    if (ref.mtvec != npc_cpu.mtvec) {
        dump("mtvec", npc_cpu.mtvec, ref.mtvec);
        ok = 0;
    }
    if (ref.mepc != npc_cpu.mepc) {
        dump("mepc", npc_cpu.mepc, ref.mepc);
        ok = 0;
    }
    if (ref.mcause != npc_cpu.mcause) {
        dump("mcause", npc_cpu.mcause, ref.mcause);
        ok = 0;
    }
    return ok;
}
