cmake_minimum_required(VERSION 3.27)
project(Asm C)

set(CMAKE_C_STANDARD 11)

set(OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/out")

add_executable(Asm
        asm/sum.c
        asm/add.c
        asm/vector_dot_product.c
        asm/array_push.c
        src/main/asm.cpp
        asm/sub.c
)
