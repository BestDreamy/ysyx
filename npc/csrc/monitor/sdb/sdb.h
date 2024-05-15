#ifndef SDB_H
#define SDB_H
#include "paddr.h"
// 指令执行， 暂停执行， 正常结束， 异常结束， difftest对比错误
enum { NPC_RUNNING, NPC_STOP, NPC_END, NPC_ABORT, NPC_QUIT };

typedef struct {
  int state;
  bool halt_ret;
  paddr_t halt_pc;
} NPC_state;
extern NPC_state npc_state;

int is_exit_status_bad();
#endif
