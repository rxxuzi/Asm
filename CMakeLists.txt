cmake_minimum_required(VERSION 3.27)
project(Asm C)

set(CMAKE_C_STANDARD 11)

add_executable(Asm
        asm/sum.c
        asm/add.c
        asm/vector_dot_product.c
        asm/array_push.c
        asm/vector.c
)