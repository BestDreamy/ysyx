#include "sdb.h"

NPC_state npc_state = {.state = NPC_STOP, .halt_ret = 0};

int is_exit_status_bad() {
    int good = (npc_state.state == NPC_END && npc_state.halt_ret) ||
               (npc_state.state == NPC_QUIT);
    return !good;
}