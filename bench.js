// bench.js
function fib(n) {
    if (n <= 1) return n;
    return fib(n-1) + fib(n-2);
}

function sieve(limit) {
    const isPrime = new Uint8Array(limit + 1);
    for (let i = 2; i * i <= limit; i++) {
        if (!isPrime[i]) {
            for (let j = i * i; j <= limit; j += i) {
                isPrime[j] = 1;
            }
        }
    }
}

let start = performance.now();
fib(35);
let fibTime = performance.now() - start;

start = performance.now();
sieve(10000000);
let sieveTime = performance.now() - start;

console.log(`JavaScript: fib=${fibTime.toFixed(2)}ms, sieve=${sieveTime.toFixed(2)}ms`);
