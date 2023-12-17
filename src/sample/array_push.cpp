#include <iostream>
#include <vector>
#include <chrono>
#define N 10000000

int main() {
    std::vector<int> v;

    v.reserve(N);

    //start time
    auto start = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < N; i++) {
        v.push_back(i * 2);
    }
    //end time
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double> elapsed = end - start;
    std::cout << "Time Taken: " << elapsed.count() << " seconds" << std::endl;
    for (int i = 0; i < 10; ++i) {
        std::cout << v[i] << " ";
    }
    std::cout << std::endl;
    std::cout << "Size of vector: " << v.size() << std::endl;
    return 0;
}