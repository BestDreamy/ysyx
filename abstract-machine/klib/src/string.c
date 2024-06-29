#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) {
  size_t i = 0;
  for (; s[i]; i ++) ;
  return i;
}

char *strcpy(char *dst, const char *src) {
  assert(dst != NULL);
  size_t i = 0;
  while (*(src + i)) {
    *(dst + i) = *(src + i);
    i ++;
  }
  *(dst + i) = '\0';
  return dst;
}

char *strncpy(char *dst, const char *src, size_t n) {
  assert(dst != NULL);
  size_t i = 0;
  for (; i < n; i ++) {
    if (*(src + i) == '\0') break;
    *(dst + i) = *(src + i);
  }
  *(dst + i) = '\0';
  return dst;
}

char *strcat(char *dst, const char *src) {
  assert(dst != NULL);
  size_t base = strlen(dst), i = 0;
  while (*(src + i)) {
    *(dst + base + i) = *(src + i);
    i ++;
  }
  *(dst + base + i) = '\0';
  return dst;
}

int strcmp(const char *s1, const char *s2) {
  size_t i = 0;
  for(; *(s1 + i) && *(s2 + i); i ++) {
    if (*(s1 + i) != *(s2 + i)) break;
  }
  return *((unsigned char*)s1 + i) - *((unsigned char*)s2 + i);
}

int strncmp(const char *s1, const char *s2, size_t n) {
  size_t i = 0;
  for(; *(s1 + i) && *(s2 + i) && i < n; i ++) {
    if (*(s1 + i) != *(s2 + i)) break;
  }
  return *((unsigned char*)s1 + i) - *((unsigned char*)s2 + i);
}

void *memset(void *s, int c, size_t n) {
  assert(s != NULL);
  for (size_t i = 0; i < n; i ++) {
    *((char*)s + i) = c;
  }
  return s; 
}

void *memmove(void *dst, const void *src, size_t n) {
  assert(dst != NULL);
  for (size_t i = n; i; i --) {
    *((char*)dst + i - 1) = *((char*)src + i - 1);
  }
  return dst;
}

void *memcpy(void *dst, const void *src, size_t n) {
  assert(dst != NULL);
  for (size_t i = 0; i < n; i ++) {
    *((char*)dst + i) = *((char*)src + i);
  }
  return dst;
}

int memcmp(const void *s1, const void *s2, size_t n) {
  for (size_t i = 0; (*((char*)s1 + i) && *((char*)s2 + i)) && i < n; i ++) {
    if (*((char*)s1 + i) != *((char*)s2 + i)) break;
  }
  return *(unsigned char*)s1 - *(unsigned char*)s2;
}

#endif
