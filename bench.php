<?php
// bench.php
function fib($n) {
    if ($n <= 1) return $n;
    return fib($n-1) + fib($n-2);
}

function sieve($limit) {
    $isPrime = array_fill(0, $limit + 1, false);
    for ($i = 2; $i * $i <= $limit; $i++) {
        if (!$isPrime[$i]) {
            for ($j = $i * $i; $j <= $limit; $j += $i) {
                $isPrime[$j] = true;
            }
        }
    }
}

$start = microtime(true);
fib(35);
$fibTime = (microtime(true) - $start) * 1000;

$start = microtime(true);
sieve(10000000);
$sieveTime = (microtime(true) - $start) * 1000;

printf("PHP: fib=%.2fms, sieve=%.2fms\n", $fibTime, $sieveTime);
