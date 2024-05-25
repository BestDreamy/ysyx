#include "verilated.h"
#include "verilated_fst_c.h"
#include "Vtop.h"
#include "macro.h"
#include "init.h"
#include "cpu.h"
#include "sdb.h"
#include <stdlib.h>
#include <assert.h>
#include "debug.h"

Vtop* dut = NULL;
VerilatedFstC* tfp = NULL;
uint32_t time_counter = TIME_RESET;

int main(int argc, char** argv) {
    welcome(argc, argv);
    dut = new Vtop;
    tfp = new VerilatedFstC;
    Verilated::traceEverOn(true);
    dut->trace(tfp, 0);
    tfp->open("sim.fst");

    cpu_init();
    tfp->close();
    delete dut;
    return is_exit_status_bad();
}
