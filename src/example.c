#include <stdio.h>

int main(void) {
    char buf[256];
    int line = 0;

    // Read from standard input line by line
    while (fgets(buf, sizeof(buf), stdin)) {
        line++;
        // Print each line with a line number
        printf("Line %d: %s", line, buf);
    }

    return 0;
}
