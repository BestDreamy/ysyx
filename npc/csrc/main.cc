#include "verilated.h"
#include "verilated_fst_c.h"
#include "Vtop.h"
#include "macro.h"
#include "init.h"
#include <stdlib.h>
#include <assert.h>
#include "debug.h"

int main(int argc, char** argv) {
    /* load_image(argv[1]); */
    welcome(argc, argv);
    Vtop* dut = new Vtop;

    VerilatedFstC* tfp = new VerilatedFstC;
    Verilated::traceEverOn(true);
    dut->trace(tfp, 0);
    tfp->open("sim.fst");

    uint32 time_counter = 0;
    dut->clk = 1; dut->rst = 1;
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
