// bench.cpp
#include <iostream>
#include <vector>
#include <chrono>

int fib(int n) {
    if (n <= 1) return n;
    return fib(n-1) + fib(n-2);
}

void sieve(int limit) {
    std::vector<bool> is_prime(limit+1, false);
    for (int i = 2; i*i <= limit; i++)
        if (!is_prime[i])
            for (int j = i*i; j <= limit; j += i)
                is_prime[j] = true;
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    volatile int r = fib(35);
    auto end = std::chrono::high_resolution_clock::now();
    double fib_time = std::chrono::duration<double, std::milli>(end - start).count();

    start = std::chrono::high_resolution_clock::now();
    sieve(10000000);
    end = std::chrono::high_resolution_clock::now();
    double sieve_time = std::chrono::duration<double, std::milli>(end - start).count();

    std::cout << "C++: fib=" << fib_time << "ms, sieve=" << sieve_time << "ms\n";
    return 0;
}
