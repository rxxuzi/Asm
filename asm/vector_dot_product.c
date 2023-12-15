#include <stdio.h>

typedef struct {
    int x, y, z;
} Vector3;

extern int vector_dot_product(Vector3 *a, Vector3 *b);

//ベクトルa,bの内積を求めるプログラム
int main() {
    Vector3 a = {1, 2, 3};
    Vector3 b = {4, 5, 6};
    int dot = vector_dot_product(&a, &b);
    printf("Dot product: %d\n", dot);
    return 0;
}
