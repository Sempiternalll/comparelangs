# bench.py
import time

def fib(n):
    if n <= 1:
        return n
    return fib(n-1) + fib(n-2)

def sieve(limit):
    is_prime = [False] * (limit + 1)
    i = 2
    while i * i <= limit:
        if not is_prime[i]:
            for j in range(i*i, limit+1, i):
                is_prime[j] = True
        i += 1

start = time.perf_counter()
fib(35)
fib_time = (time.perf_counter() - start) * 1000

start = time.perf_counter()
sieve(10_000_000)
sieve_time = (time.perf_counter() - start) * 1000

print(f"Python: fib={fib_time:.2f}ms, sieve={sieve_time:.2f}ms")
