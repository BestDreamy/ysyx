#include "verilated.h"
#include "verilated_fst_c.h"
#include "Vtop.h"
/*
#include "ifu.v"
#include "defines.v"
#include "pcReg.v"
#include "rom.v"
*/
#include <cstdint>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
typedef uint32_t uint32;
typedef int32_t  int32;

int main(int argc, char** argv) {
    Vtop* dut = new Vtop;

    VerilatedFstC* tfp = new VerilatedFstC;
    Verilated::traceEverOn(true);
    dut->trace(tfp, 0);
    tfp->open("wave.fst");

    uint time_counter = 0;
    uint clk = 0, rst = 1;
    while (!Verilated::gotFinish() and time_counter < 100) {
        if (time_counter == 3) {
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
