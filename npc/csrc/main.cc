#include "verilated.h"
#include "macro.h"
#include "init.h"
#include "cpu.h"
#include "sdb.h"
#include <stdlib.h>
#include <assert.h>
#include "debug.h"

VysyxSoCFull* dut = NULL;
VerilatedFstC* tfp = NULL;
uint32_t time_counter = TIME_RESET;

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    welcome(argc, argv);
    dut = new VysyxSoCFull;
    tfp = new VerilatedFstC;
    Verilated::traceEverOn(true);
    dut->trace(tfp, 0);
    tfp->open("sim.fst");

    cpu_init();
    tfp->close();
    delete dut;
    return is_exit_status_bad();
}
