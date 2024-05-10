#ifndef INIT_H
#define INIT_H
#include <stdint.h>
#include <stddef.h>
extern char *img_file;
extern char *diff_so_file;
extern bool is_batch_mode;
extern int  difftest_port;
extern size_t img_size;

uint64_t load_image();

void welcome(int argc, char *argv[]);
int parse_args(int argc, char *argv[]);
void sdb_set_batch_mode();
#endif
