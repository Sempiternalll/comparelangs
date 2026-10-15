// bench.swift
import Foundation

func fib(_ n: Int) -> Int {
    if n <= 1 { return n }
    return fib(n-1) + fib(n-2)
}

func sieve(_ limit: Int) {
    var isPrime = [Bool](repeating: false, count: limit + 1)
    var i = 2
    while i * i <= limit {
        if !isPrime[i] {
            var j = i * i
            while j <= limit {
                isPrime[j] = true
                j += i
            }
        }
        i += 1
    }
}

let start = DispatchTime.now()
_ = fib(35)
let fibTime = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000

let start2 = DispatchTime.now()
sieve(10_000_000)
let sieveTime = Double(DispatchTime.now().uptimeNanoseconds - start2.uptimeNanoseconds) / 1_000_000

print(String(format: "Swift: fib=%.2fms, sieve=%.2fms", fibTime, sieveTime))
