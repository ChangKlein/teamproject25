#include <stdio.h>

int main(void) {
    int x;
    if (scanf("%d", &x) != 1) {
        fprintf(stderr, "Failed to read input\n");
        return 1;
    }
    printf("%d\n", x * 2);
    return 0;
}
