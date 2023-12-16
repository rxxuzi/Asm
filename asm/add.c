#include <stdio.h>

extern int add_numbers(int, int); // アセンブリ言語の関数を宣言

int main() {
    int a ;
    int b ;
    // a と b に数値を入力する
    printf("Enter two numbers: ");
    scanf("%d %d", &a, &b);
    int sum = add_numbers(a, b); // 関数を呼び出す
    printf("Sum: %d\n", sum);
    return 0;
}
