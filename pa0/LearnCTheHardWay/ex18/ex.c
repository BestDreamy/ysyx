#include <stdio.h>
#include <stdlib.h> // malloc
#include <string.h> // memcpy
#include <errno.h>

void die(const char *message) {
	if(errno) {
		perror(message);
	}	
	else {
		printf("ERROR: %s\n", message);
	}
}

int sorted_order(int a, int b)
{
	return a - b;
}

int reverse_order(int a, int b)
{
	return b - a;
}

int strange_order(int a, int b)
{
	if(a == 0 || b == 0)
		return 0;
	return a % b;
}

int *bubble_sort(int *numbers, int count, int (*cmp)(int a, int b))
{
    int temp = 0;
    int i = 0;
    int j = 0;
    int *target = malloc(count * sizeof(int));

    if(!target) die("Memory error.");

    memcpy(target, numbers, count * sizeof(int));

    for(i = 0; i < count; i++) {
        for(j = 0; j < count - 1; j++) {
            if(cmp(target[j], target[j+1]) > 0) {
                temp = target[j+1];
                target[j+1] = target[j];
                target[j] = temp;
            }
        }
    }

    return target;
}

typedef int (*compare)(int a, int b);
void test_sorting(int *numbers, int cnt, compare cmp){
	int *sorted = bubble_sort(numbers, cnt, cmp);
	if(! sorted) die("Fail to sort as requested.");

	for(int i = 0; i < cnt; i ++) {
		printf("%d ", sorted[i]);
	}
	puts("");
	free(sorted);
}

int main(int argc, char *argv[]) {
	if(argc < 2) die("USAGE: ex18 4 3 1 5 6");

	int cnt = argc - 1;
	char **str = argv + 1;
	int *numbers = malloc(cnt * sizeof(int));
	if(! numbers) die("Memeory error");

	for(int i = 0; i < cnt; i ++) {
		numbers[i] = atoi(str[i]);
	}

	test_sorting(numbers, cnt, sorted_order);
	test_sorting(numbers, cnt, reverse_order);
	test_sorting(numbers, cnt, strange_order);

	free(numbers);
	return 0;
}
