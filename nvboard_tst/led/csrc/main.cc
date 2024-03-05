#include <nvboard.h>
#include "Vlight.h"

static TOP_NAME dut;

// Function declare 
void nvboard_bind_all_pins(TOP_NAME* dut);

static void single_cycle() {
    dut.clk = 0; dut.eval();
    dut.clk = 1; dut.eval();
}

void reset(int n) {
    dut.rst = 1;
    while(n --> 0) {
        single_cycle();
    }
    dut.rst = 0;
}

signed main() {
    nvboard_bind_all_pins(&dut);
    nvboard_init();

    reset(10);

    while(true) {
        nvboard_update();
        single_cycle();
    }

    nvboard_quit();
    return 0;
}
