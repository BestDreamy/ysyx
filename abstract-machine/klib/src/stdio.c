#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

// int vsprintf(char *out, const char *fmt, va_list ap) {
//     int p = 0;
//     bool isSubstitute = 0;
//     char fillChar = '\0';
//     int  fillWidth = 0;
//     for (int i = 0; fmt[i]; i ++) {
//         if (isSubstitute) {
//             if (fmt[i] == '0' && fillChar == '\0') {
//                 fillChar = fmt[i];
//                 continue;
//             }
//             if (fmt[i] >= '0' && fmt[i] <= '9' && fillChar != '\0') {
//                 fillWidth = fmt[i] - '0';
//                 continue;
//             }

//             switch (fmt[i]) {
//                 case 's': {
//                     char *s = va_arg(ap, char*);
//                     while(*s) {
//                         out[p ++] = *s, s ++;
//                     }
//                 } break;
//                 case 'd': {
//                     int d = va_arg(ap, int);
//                     if (d < 0) {
//                         d = -d;
//                         out[p ++] = '-';
//                     }
//                     char s[64];
//                     int wid = 0;

//                     do {
//                         s[wid ++] = '0' + d % 10;
//                         d /= 10;
//                     } while(d);

//                     while (wid < fillWidth) {
//                         out[p ++] = fillChar;
//                         fillWidth --;
//                     }
//                     for ( wid --; wid >= 0; wid --) {
//                         out[p ++] = s[wid];
//                     }
//                 } break;
//                 case 'c': {
//                     char ch = va_arg(ap, int);
//                     out[p ++] = ch;
//                 } break;
//             }
//             isSubstitute = 0;
//             fillChar = '\0';
//             fillWidth = 0;
//             continue;
//         }

//         if (fmt[i] == '%') {
//             isSubstitute = 1;
//             continue;
//         }
//         else {
//             out[p ++] = fmt[i];
//         }
//     }

//     out[p] = '\0';
//     return p;
// }

// int printf(const char *fmt, ...) {
//     va_list ap;
//     va_start(ap, fmt); // ap's address start from (&fmt)
//     char buffer[4096];
//     int len = vsprintf(buffer, fmt, ap);
//     for (int i = 0; i < len; i ++) {
//         putch(buffer[i]);
//     }
//     va_end(ap);
//     return len;
//     return 0;
// }

// int sprintf(char *out, const char *fmt, ...) {
//     va_list ap;
//     va_start(ap, fmt); // ap's address start from (&fmt)
//     int len = vsprintf(out, fmt, ap);
//     va_end(ap);
//     return len;
// }



// int snprintf(char *out, size_t n, const char *fmt, ...) {
//   panic("Not implemented");
// }

// int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
//   panic("Not implemented");
// }

int printf(const char *fmt, ...) {
  va_list ap;
  va_start(ap, fmt);
  char out[4096];
  int length = vsprintf(out, fmt, ap);
  for (int i = 0; i < length; i++) {
    putch(out[i]);
  }
  va_end(ap);
  return length;
}

int sprintf(char *out, const char *fmt, ...) {
  va_list ap;
  va_start(ap, fmt);
  int length = vsprintf(out, fmt, ap);
  va_end(ap);
  return length;
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  va_list ap;
  va_start(ap, fmt);
  int length = vsnprintf(out, n, fmt, ap);
  va_end(ap);
  return length;
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  return vsnprintf(out, -1, fmt, ap);
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  int pos = 0;

  for (; *fmt != '\0'; fmt++) {
    while (*fmt != '%' && *fmt != '\0') {
      out[pos++] = *fmt++;
      if (pos > n) {
        return n;
      }
    }

    if (*fmt == '%') {
      fmt++;
    }
    else if (*fmt == '\0') {
      break;
    }

    char padding = ' ';
    if (*fmt == '0') {
      padding = '0';
      fmt++;
    }

    int width = 0;
    while (*fmt >= '0' && *fmt <= '9') {
      width = width * 10 + *fmt++ - '0';
    }

    switch (*fmt) {
      case 's': {
        char *s = va_arg(ap, char *);
        while (*s != '\0') {
          out[pos++] = *s++;
          if (pos > n) {
            return n;
          }
        }
        break;
      }
      case 'd': {
        int d = va_arg(ap, int);
        if (d < 0) {
            d = -d;
            out[pos++] = '-';
            if (pos > n) {
              return n;
            }
        }
        char num[20] = {0};
        int rem = 0;
        int length = 0;

        do {
          rem = d % 10;
          d = d / 10;
          num[length++] = rem + '0';
        } while (d > 0);

        while (length < width) {
          out[pos++] = padding;
          width--;
          if (pos > n) {
            return n;
          }
        }

        length--;
        for (; length >= 0; length--) {
          out[pos++] = num[length];
          if (pos > n) {
              return n;
          }
        }
        break;
      }
      case 'p':
      case 'x': {
          uint32_t d = va_arg(ap, uint32_t);
          char num[20] = {0};
          int rem = 0;
          int length = 0;

          do {
            rem = d % 16;
            d = d / 16;
            if (rem <= 9) {
              num[length++] = rem + '0';
            }
            else {
              num[length++] = rem - 10 + 'a';
            }
          } while (d > 0);

          while (length < width) {
            out[pos++] = padding;
            width--;
            if (pos > n) {
              return n;
            }
          }

          out[pos++] = '0';
          if (pos > n) {
            return n;
          }

          out[pos++] = 'x';
          if (pos > n) {
            return n;
          }

          length--;
          for (; length >= 0; length--) {
            out[pos++] = num[length];
            if (pos > n) {
              return n;
            }
          }
          break;
        }
      }
    }

  if (pos > n) {
    return n;
  }

  out[pos] = '\0';
  return pos;
}

#endif
