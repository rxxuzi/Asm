#include <stdio.h>

extern void write(const char *filename, const char *string);

int main() {
    write("sample.txt", "Hello, World!\n");
    return 0;
}

