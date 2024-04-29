#ifndef DIFFTEST_H
#define DIFFTEST_H
enum { DIFFTEST_TO_DUT, DIFFTEST_TO_REF };

void init_difftest(const char *ref_so_file, long img_size, int port);
#endif
