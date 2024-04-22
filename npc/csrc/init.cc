#include "init.h"
#include "macro.h"
#include "debug.h"
#include <stdio.h>

uint64_t load_image(char* path) {
  FILE *fp = fopen(path, "rb");
  // Assert(fp != NULL, "Can not open inst file!\n");
  
  fseek(fp, 0, SEEK_END);
  size_t size = ftell(fp);
  fseek(fp, 0, SEEK_SET);
  int ret = fread(guest_to_host(RESET_VECTOR), size, 1, fp);
  fclose(fp);
  return size;
}