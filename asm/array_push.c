#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE 10000000 // 配列のサイズ

extern void push(int *array, int size); // アセンブリ言語の関数を宣言

int main() {
    int *array = (int *)malloc(SIZE * sizeof(int));
    if (array == NULL) {
        perror("Memory allocation failed");
        return 1;
    }

    clock_t start, end;
    double cpu_time_used;

    start = clock();

    push(array, SIZE);

    end = clock();

    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    printf("Time taken: %f seconds\n", cpu_time_used);

    // 結果の確認（最初の10個と最後の10個を表示）
    for (int i = 0; i < 10; i++) {
        printf("%d ", array[i]);
    }
    printf("\n... ");
    for (int i = SIZE - 10; i < SIZE; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");

    free(array);
    return 0;
}
