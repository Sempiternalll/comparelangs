#!/bin/bash
# run_benchmarks.sh
# اجرای متناوب بنچمارک‌ها برای کاهش اثر گرم شدن سیستم

set -e

# ==================== تنظیمات ====================
RUNS=5                      # تعداد اجرا برای هر زبان
WARMUP=1                    # تعداد اجرای اولیه (دور ریخته می‌شود)

# رنگ‌ها
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ==================== نصب پیش‌نیازها ====================
echo -e "${YELLOW}=== Installing dependencies ===${NC}"

# PHP بدون Xdebug
sudo apt install -y php-cli
sudo phpdismod xdebug 2>/dev/null || true

# Java
sudo apt install -y openjdk-21-jdk 2>/dev/null || true

# Go
if ! command -v go &>/dev/null; then
    wget -q https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
    export PATH=$PATH:/usr/local/go/bin
fi

# Node.js
if ! command -v node &>/dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# .NET SDK برای C#
if ! command -v dotnet &>/dev/null; then
    wget -q https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
    chmod +x dotnet-install.sh
    ./dotnet-install.sh --channel 8.0
    export PATH=$PATH:$HOME/.dotnet
fi

# Swift
if ! command -v swift &>/dev/null; then
    # روش tarball
    SWIFT_VER="swift-5.10.1-RELEASE"
    SWIFT_UBUNTU="ubuntu22.04"
    wget -q "https://download.swift.org/${SWIFT_VER%-*}-release/${SWIFT_UBUNTU}/${SWIFT_VER}/${SWIFT_VER}-${SWIFT_UBUNTU}.tar.gz" -O swift.tar.gz
    mkdir -p $HOME/swift
    tar -xzf swift.tar.gz -C $HOME/swift --strip-components=1
    export PATH=$HOME/swift/usr/bin:$PATH
fi

# ==================== کامپایل ====================
echo -e "${YELLOW}=== Compiling ===${NC}"

gcc -O3 -march=native -o bench_c bench.c
g++ -O3 -march=native -funroll-loops -o bench_cpp bench.cpp
rustc -O -C target-cpu=native -o bench_rust bench.rs
javac Bench.java

# C# (پروژه موقت)
mkdir -p cs_bench
cat > cs_bench/cs_bench.csproj <<'EOF'
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <Optimize>true</Optimize>
  </PropertyGroup>
</Project>
EOF
cp Bench.cs cs_bench/Program.cs
(cd cs_bench && dotnet build -c Release -v quiet)

# Swift
swiftc -O bench.swift -o bench_swift

# Go
(cd . && go build -o bench_go bench.go) 2>/dev/null || true

# ==================== تابع اجرا ====================
run_bench() {
    local name=$1
    shift
    echo -e "${GREEN}--- $name ---${NC}"
    # warm-up
    for ((i=0; i<WARMUP; i++)); do "$@" > /dev/null 2>&1; done
    # اجرای اصلی
    for ((i=1; i<=RUNS; i++)); do
        "$@"
    done
}

# ==================== اجرای متناوب ====================
# به جای اجرای همه RUNS برای یک زبان، زبان‌ها را به تناوب اجرا می‌کنیم
# تا اثر thermal throttling و نویز سیستم پخش شود
echo -e "${YELLOW}=== Running benchmarks (interleaved) ===${NC}"

declare -A BENCHES
BENCHES[c]="./bench_c"
BENCHES[cpp]="./bench_cpp"
BENCHES[rust]="./bench_rust"
BENCHES[go]="./bench_go"
BENCHES[java]="java -cp . Bench"
BENCHES[csharp]="dotnet cs_bench/bin/Release/net8.0/cs_bench.dll"
BENCHES[swift]="./bench_swift"
BENCHES[python]="python3 bench.py"
BENCHES[javascript]="node bench.js"
BENCHES[php]="php -d xdebug.mode=off -d memory_limit=512M bench.php"

ORDER=(c cpp rust go java csharp swift python javascript php)

# warm-up همه
for lang in "${ORDER[@]}"; do
    eval "${BENCHES[$lang]}" > /dev/null 2>&1 || true
done

# اجرای متناوب
for ((run=1; run<=RUNS; run++)); do
    echo ""
    echo -e "${YELLOW}========== Run $run/$RUNS ==========${NC}"
    for lang in "${ORDER[@]}"; do
        eval "${BENCHES[$lang]}" 2>/dev/null || echo "$lang: FAILED"
    done
done

echo ""
echo -e "${GREEN}=== Done ===${NC}"
