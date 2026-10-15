// bench.rs
use std::time::Instant;

fn fib(n: u64) -> u64 {
    if n <= 1 { n } else { fib(n-1) + fib(n-2) }
}

fn sieve(limit: usize) {
    let mut is_prime = vec![false; limit + 1];
    let mut i = 2;
    while i * i <= limit {
        if !is_prime[i] {
            let mut j = i * i;
            while j <= limit {
                is_prime[j] = true;
                j += i;
            }
        }
        i += 1;
    }
}

fn main() {
    let start = Instant::now();
    let _ = fib(35);
    let fib_time = start.elapsed().as_secs_f64() * 1000.0;

    let start = Instant::now();
    sieve(10_000_000);
    let sieve_time = start.elapsed().as_secs_f64() * 1000.0;

    println!("Rust: fib={:.2}ms, sieve={:.2}ms", fib_time, sieve_time);
}
