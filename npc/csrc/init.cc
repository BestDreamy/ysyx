#include "init.h"
#include "macro.h"
#include "debug.h"
#include "paddr.h"
#include <stdio.h>

uint64_t load_image(const char* path) {
  Assert(path != NULL, "The binary file error!\n");

  FILE *fp = fopen(path, "rb");
  Assert(fp != NULL, "Can not open instruction file!\n");
  fseek(fp, 0, SEEK_END);
  size_t size = ftell(fp);
  fseek(fp, 0, SEEK_SET);
  bool ret = fread(guest_to_host(RESET_VECTOR), size, 1, fp);
  Assert(ret == 1, "Load the instrction to the pmem error!\n");
  fclose(fp);
  return size;
}