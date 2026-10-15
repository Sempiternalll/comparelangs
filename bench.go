// bench.go
package main

import (
    "fmt"
    "time"
)

func fib(n int) int {
    if n <= 1 { return n }
    return fib(n-1) + fib(n-2)
}

func sieve(limit int) {
    isPrime := make([]bool, limit+1)
    for i := 2; i*i <= limit; i++ {
        if !isPrime[i] {
            for j := i * i; j <= limit; j += i {
                isPrime[j] = true
            }
        }
    }
}

func main() {
    start := time.Now()
    _ = fib(35)
    fibTime := time.Since(start).Seconds() * 1000

    start = time.Now()
    sieve(10000000)
    sieveTime := time.Since(start).Seconds() * 1000

    fmt.Printf("Go: fib=%.2fms, sieve=%.2fms\n", fibTime, sieveTime)
}
