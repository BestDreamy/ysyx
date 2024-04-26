#ifndef INIT_H
#define INIT_H
#include <stdint.h>

uint64_t load_image();

void welcome(int argc, char *argv[]);
int parse_args(int argc, char *argv[]);
void sdb_set_batch_mode();
#endif
