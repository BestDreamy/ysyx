#ifndef SDB_H
#define SDB_H
enum { NEMU_RUNNING, NEMU_STOP, NEMU_END, NEMU_ABORT, NEMU_QUIT };

typedef struct {
  int state;
  paddr_t halt_pc;
} NPCState;
extern NPCState npc_state;
#endif