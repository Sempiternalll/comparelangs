#!/bin/bash
# run_benchmarks.sh

echo "=== Installing dependencies ==="
sudo apt install -y php-cli openjdk-21-jdk golang-go rustc cargo nodejs

echo "=== Compiling ==="
gcc -O3 -o bench_c bench.c
g++ -O3 -o bench_cpp bench.cpp
rustc -O -o bench_rust bench.rs
javac Bench.java

echo "=== Running benchmarks (3 runs each) ==="

run_bench() {
    local name=$1
    local cmd=$2
    echo "--- $name ---"
    for i in 1 2 3; do
        $cmd
    done
}

run_bench "C" "./bench_c"
run_bench "C++" "./bench_cpp"
run_bench "Rust" "./bench_rust"
run_bench "Go" "go run bench.go"
run_bench "Java" "java Bench"
run_bench "Python" "python3 bench.py"
run_bench "JavaScript" "node bench.js"
run_bench "PHP" "php bench.php"
