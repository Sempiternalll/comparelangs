// Bench.cs
using System;
using System.Diagnostics;

class Bench {
    static int Fib(int n) {
        if (n <= 1) return n;
        return Fib(n-1) + Fib(n-2);
    }

    static void Sieve(int limit) {
        bool[] isPrime = new bool[limit + 1];
        for (int i = 2; i * i <= limit; i++)
            if (!isPrime[i])
                for (int j = i * i; j <= limit; j += i)
                    isPrime[j] = true;
    }

    static void Main() {
        var sw = Stopwatch.StartNew();
        Fib(35);
        double fibTime = sw.Elapsed.TotalMilliseconds;

        sw.Restart();
        Sieve(10_000_000);
        double sieveTime = sw.Elapsed.TotalMilliseconds;

        Console.WriteLine($"C#: fib={fibTime:F2}ms, sieve={sieveTime:F2}ms");
    }
}
