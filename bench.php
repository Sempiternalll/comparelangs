<?php
// bench.php
ini_set('memory_limit', '512M');

function fib($n) {
    if ($n <= 1) return $n;
    return fib($n-1) + fib($n-2);
}

function sieve($limit) {
    // SplFixedArray حافظه کمتری از آرایه معمولی مصرف می‌کند
    $isPrime = new SplFixedArray($limit + 1);
    // مقادیر به صورت پیش‌فرض null هستند، پس صریحاً false می‌گذاریم
    for ($i = 0; $i <= $limit; $i++) {
        $isPrime[$i] = false;
    }

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
