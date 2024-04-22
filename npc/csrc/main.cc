#include "verilated.h"
#include "verilated_fst_c.h"
#include "Vtop.h"
#include "macro.h"
#include "init.h"
#include <stdlib.h>
#include <assert.h>

int main(int argc, char** argv) {
    load_image(argv[1]);
    Vtop* dut = new Vtop;

    VerilatedFstC* tfp = new VerilatedFstC;
    Verilated::traceEverOn(true);
    dut->trace(tfp, 0);
    tfp->open("wave.fst");

    uint32 time_counter = 0;
    uint32 clk = 0, rst = 1;
    while (!Verilated::gotFinish() and time_counter < 100) {
        if (time_counter == 2) {
            rst = 0;
        }
        dut->clk = clk; dut->eval();
        dut->rst = rst;
        
        clk = 1 - clk;
        tfp->dump(time_counter ++);
    }
    tfp->close();
    delete dut;
    return 0;
}
