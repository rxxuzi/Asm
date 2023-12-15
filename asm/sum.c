#include <stdio.h>

extern long sum(long n); // アセンブリ言語の関数を宣言

int main() {
    long n, result;

    printf("Enter a number: ");
    scanf("%ld", &n);

    result = sum(n); // 関数を呼び出して総和を計算

    printf("Sum of numbers up to %ld is %ld\n", n, result);
    return 0;
}