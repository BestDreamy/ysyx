/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include "sdb.h"

#define NR_WP 32

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  char *expr;
  word_t old_val;
} WP;

static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL;

void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
  }

  head = NULL;
  free_ = wp_pool;
}

void new_wp(char *args, bool *success) {
  if (free_ == NULL) assert(0);
  WP *p = free_;
  free_ = free_->next;

  { // New watchpoint
    p->next = head;
    p->old_val = expr(args, success);
    p->expr = strdup(args);
  }
  head = p; 
}

void free_wp(int no) {
  WP *ptr = head, *pre = NULL;
  while (ptr != NULL) {
    if (ptr->NO == no) break;
    pre = ptr;
    ptr = ptr->next;
  }
  if (pre != NULL) pre->next = ptr->next;
  else head = NULL;
  if (ptr == NULL || ptr->NO != no) printf("Can't find watch point !\n"), assert(0);

  { // Free watchpoint(ptr)
    ptr->next = free_;
    free_ = ptr;
  }
}

void wp_display() {
  WP *ptr = head;
  if (head == NULL) {
    printf("No watchpoint !\n");
  } 
  else {
    printf("Display watchpoints:\n");
    for(; ptr != NULL; ptr = ptr->next) {
      #if defined(CONFIG_ISA_riscv32)
      printf("%d\t%s\t%d\n", ptr->NO, ptr->expr, ptr->old_val);
      #elif defined(CONFIG_ISA_riscv64)
      printf("%d\t%s\t%ld\n", ptr->NO, ptr->expr, ptr->old_val);
      #endif
    }
  }
}

void scan_wp() {
  for (WP *p = head; p != NULL; p = p->next) {
    bool *success = &(bool){true};
    word_t new_val = expr(p->expr, success);
    if (*success == false) assert(0);
    if (p->old_val != new_val) {
      nemu_state.state = NEMU_STOP;
      p->old_val = new_val;
      printf("watchpoint %d has triggered !\n", p->NO);
      break;
    }
  }
}
