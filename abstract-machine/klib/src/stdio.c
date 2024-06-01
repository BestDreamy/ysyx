#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

int vsprintf(char *out, const char *fmt, va_list ap) {
    int p = 0;
    bool isSubstitute = 0;
    char fillChar = '\0';
    int  fillWidth = 0;
    for (int i = 0; fmt[i]; i ++) {
        if (isSubstitute) {
            if (fmt[i] == '0' && fillChar == '\0') {
                fillChar = fmt[i];
                continue;
            }
            if (fmt[i] >= '0' && fmt[i] <= '9' && fillChar != '\0') {
                fillWidth = fmt[i] - '0';
                continue;
            }

            switch (fmt[i]) {
                case 's': {
                    char *s = va_arg(ap, char*);
                    while(*s) {
                        out[p ++] = *s, s ++;
                    }
                } break;
                case 'd': {
                    int d = va_arg(ap, int);
                    if (d < 0) {
                        d = -d;
                        out[p ++] = '-';
                    }
                    char s[64];
                    int wid = 0;

                    do {
                        s[wid ++] = '0' + d % 10;
                        d /= 10;
                    } while(d);

                    while (wid < fillWidth) {
                        out[p ++] = fillChar;
                        fillWidth --;
                    }
                    for ( wid --; wid >= 0; wid --) {
                        out[p ++] = s[wid];
                    }
                } break;
                case 'c': {
                    char ch = va_arg(ap, int);
                    out[p ++] = ch;
                } break;
            }
            isSubstitute = 0;
            fillChar = '\0';
            fillWidth = 0;
            continue;
        }

        if (fmt[i] == '%') {
            isSubstitute = 1;
            continue;
        }
        else {
            out[p ++] = fmt[i];
        }
    }

    out[p] = '\0';
    return p;
}

int printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt); // ap's address start from (&fmt)
    char buffer[4096];
    int len = vsprintf(buffer, fmt, ap);
    for (int i = 0; i < len; i ++) {
        putch(buffer[i]);
    }
    va_end(ap);
    return len;
    return 0;
}

int sprintf(char *out, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt); // ap's address start from (&fmt)
    int len = vsprintf(out, fmt, ap);
    va_end(ap);
    return len;
}



int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

#endif
