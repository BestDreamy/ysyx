#include <nvboard.h>
#include "Vsel.h"

static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME*);

void single_cycle() {
    dut.eval();
}

signed main() {
    nvboard_bind_all_pins(&dut);
    nvboard_init();

    while(true) {
        nvboard_update();
        single_cycle();
    }

    nvboard_quit();
    return 0;
}
