// bench.c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int fib(int n) {
    if (n <= 1) return n;
    return fib(n-1) + fib(n-2);
}

void sieve(int limit) {
    char *is_prime = calloc(limit+1, 1);
    for (int i = 2; i*i <= limit; i++)
        if (!is_prime[i])
            for (int j = i*i; j <= limit; j += i)
                is_prime[j] = 1;
    free(is_prime);
}

int main() {
    clock_t start = clock();
    volatile int r = fib(35);
    double fib_time = (double)(clock() - start) / CLOCKS_PER_SEC * 1000;

    start = clock();
    sieve(10000000);
    double sieve_time = (double)(clock() - start) / CLOCKS_PER_SEC * 1000;

    printf("C: fib=%.2fms, sieve=%.2fms\n", fib_time, sieve_time);
    return 0;
}
