#include "verilated.h"
#include "verilated_fst_c.h"
#include "Vtop.h"
#include "macro.h"
#include "init.h"
#include "cpu.h"
#include <stdlib.h>
#include <assert.h>
#include "debug.h"

Vtop* dut = NULL;
VerilatedFstC* tfp = NULL;

int main(int argc, char** argv) {
    welcome(argc, argv);
    dut = new Vtop;
    tfp = new VerilatedFstC;
    Verilated::traceEverOn(true);
    dut->trace(tfp, 0);
    tfp->open("sim.fst");

    uint32 time_counter = 0;
    cpu_init();
    while (!Verilated::gotFinish() and time_counter < 50) {
        if (time_counter == 2) {
            dut->rst = 0;
        }
        dut->clk = 1 - dut->clk;
        dut->eval();
        tfp->dump(time_counter ++);
    }
    tfp->close();
    delete dut;
    return 0;
}
