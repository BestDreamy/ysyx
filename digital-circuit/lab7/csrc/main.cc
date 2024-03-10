#include <nvboard.h>
#include "Vtop.h"

static Vtop dut;

void nvboard_bind_all_pins(Vtop*);

void single_cycle() {
    dut.clk_i = 0;
    dut.eval();
    dut.clk_i = 1;
    dut.eval();
}

void reset (int n) {
    dut.clrn_i = 0;
    while(n --> 0) {
        single_cycle();
    }
    dut.clrn_i = 1;
}

signed main() {
    nvboard_bind_all_pins(&dut);
    nvboard_init();

    reset (50);
    while(true) {
        nvboard_update();
        single_cycle();
    }

    nvboard_quit();
    return 0;
}
