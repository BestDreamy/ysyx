#include <stdio.h>
/* #include <sys/time.h> */
#include <NDL.h>

int main() {
    /* struct timeval tv; */
    /* gettimeofday(&tv, NULL); */
    /* int ms = 1; */
    /* while (1) { */
    /*     // Convert s and us into ms */
    /*     // Break when up to 500ms  */
    /*     while (tv.tv_sec * 1000 + tv.tv_usec / 1000 < ms * 500) { */
    /*         gettimeofday(&tv, NULL); */
    /*     } */
    /**/
    /*     printf("ms = %d\n", ms * 500); */
    /*     ms ++; */
    /* } */
    /* return 0; */

    int ms = 1;
    while (1) {
        while (NDL_GetTicks() < ms * 500) ;

        printf("ms = %d\n", ms * 500);
        ms ++;
    }
    return 0;
}
