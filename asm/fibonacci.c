#include <stdio.h>

extern long fibonacci(long n);

int main(void) {
    long n;
    printf("Enter a number: ");
    scanf("%ld", &n);

    for (long i = 0; i <= n; i++) {
        printf("%ld", fibonacci(i));
        if (i < n) {
            printf(",");
        }
    }

    printf("\n");
    return 0;
}
