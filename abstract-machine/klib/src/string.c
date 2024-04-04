#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) {
  size_t i = 0;
  for (; s[i]; i ++) ;
  return i - 1;
}

char *strcpy(char *dst, const char *src) {
  size_t i = 0;
  while (*(src + i)) {
    *(dst + i) = *(src + i);
    i ++;
  }
  *(dst + i) = '\0';
  return dst;
}

char *strncpy(char *dst, const char *src, size_t n) {
  for (size_t = 0; i < n; i ++) {
    if (*(src + i) == '\0') break;
    *(dst + i) = *(src + i);
  }
  *(dst + i) = '\0';
  return dst;
}

char *strcat(char *dst, const char *src) {
  size_t base = strlen(dst), i = 0;
  while (*(src + i)) {
    *(dst + base + i) = *(src + i);
    i ++;
  }
  *(dst + base + i) = '\0';
  return dst;
}

int strcmp(const char *s1, const char *s2) {
  size_t n = strlen(s1), m = strlen(s2), i = 0;
  bool ok = (n == m);
  while (*(s1 + i) && *(s2 + i) && ok) {
    if (*(s1 + i) == *(s2 + i)) continue;
    ok = 0;
  }
  return ok;
}

int strncmp(const char *s1, const char *s2, size_t x) {
  size_t n = strlen(s1), m = strlen(s2);
  bool ok = (n >= x && m >= x);
  for (size_t i = 0 ; i < x && ok; i ++) {
    if (*(s1 + i) == *(s2 + i)) continue;
    ok = 0;
  }
  return ok;
}

void *memset(void *s, int c, size_t n) {
  panic("Not implemented");
}

void *memmove(void *dst, const void *src, size_t n) {
  panic("Not implemented");
}

void *memcpy(void *out, const void *in, size_t n) {
  panic("Not implemented");
}

int memcmp(const void *s1, const void *s2, size_t n) {
  panic("Not implemented");
}

#endif
