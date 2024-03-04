#include "verilated.h"
#include "verilated_fst_c.h"
#include "Vswitch.h"
#include <cstdint>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
typedef uint32_t uint32;
typedef int32_t  int32;

int main(int argc, char** argv) {
    Vswitch* dut = new Vswitch;

    VerilatedFstC* tfp = new VerilatedFstC;
    Verilated::traceEverOn(true);
    dut->trace(tfp, 0);
    tfp->open("wave.fst");

    uint time_counter = 0;
    while (!Verilated::gotFinish() and time_counter < 50) {
        int a = rand() & 1;
        int b = rand() & 1;
        dut->a = a;
        dut->b = b;
        dut->eval();
        printf("a = %d, b = %d, f = %d\n", a, b, dut->f);

        tfp->dump(time_counter ++);
        assert(dut->f == (a ^ b));
    }
    tfp->close();
    delete dut;
    return 0;
}
