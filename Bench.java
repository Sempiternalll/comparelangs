// Bench.java
public class Bench {
    static int fib(int n) {
        if (n <= 1) return n;
        return fib(n-1) + fib(n-2);
    }

    static void sieve(int limit) {
        boolean[] isPrime = new boolean[limit + 1];
        for (int i = 2; i * i <= limit; i++)
            if (!isPrime[i])
                for (int j = i * i; j <= limit; j += i)
                    isPrime[j] = true;
    }

    public static void main(String[] args) {
        long start = System.nanoTime();
        int r = fib(35);
        double fibTime = (System.nanoTime() - start) / 1_000_000.0;

        start = System.nanoTime();
        sieve(10_000_000);
        double sieveTime = (System.nanoTime() - start) / 1_000_000.0;

        System.out.printf("Java: fib=%.2fms, sieve=%.2fms%n", fibTime, sieveTime);
    }
}
