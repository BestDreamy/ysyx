#ifndef SDB_H
#define SDB_H
enum { NPC_RUNNING, NPC_STOP, NPC_END, NPC_ABORT, NPC_QUIT };

typedef struct {
  int state;
  bool halt_ret;
  paddr_t halt_pc;
} NPC_state;
extern NPC_state npc_state;
#endif