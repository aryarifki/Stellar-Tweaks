#!/bin/bash

# Create dummy files
echo "1000" > test_file
touch test_file_ro
chmod 444 test_file_ro

# Benchmark stellar_apply_param original vs optimized
stellar_apply_param_orig() {
    [ ! -f "$2" ] && return 1
    chmod 666 "$2" >/dev/null 2>&1
    echo "$1" > "$2" 2>/dev/null
    chmod 444 "$2" >/dev/null 2>&1
}

stellar_apply_param_opt() {
    [ ! -f "$2" ] && return 1
    echo "$1" > "$2" 2>/dev/null && return 0
    chmod 666 "$2" >/dev/null 2>&1
    echo "$1" > "$2" 2>/dev/null
    chmod 444 "$2" >/dev/null 2>&1
}

# Benchmark cat vs read
echo "Benchmarking cat vs read..."
start=$(date +%s%N)
for i in {1..1000}; do
    val=$(cat test_file)
done
end=$(date +%s%N)
echo "cat: $((end-start)) ns"

start=$(date +%s%N)
for i in {1..1000}; do
    read -r val < test_file
done
end=$(date +%s%N)
echo "read: $((end-start)) ns"

# Benchmark apply_param on writable file
echo "Benchmarking apply_param on writable file..."
chmod 666 test_file
start=$(date +%s%N)
for i in {1..1000}; do
    stellar_apply_param_orig "1000" "test_file"
done
end=$(date +%s%N)
echo "Original: $((end-start)) ns"

start=$(date +%s%N)
for i in {1..1000}; do
    stellar_apply_param_opt "1000" "test_file"
done
end=$(date +%s%N)
echo "Optimized: $((end-start)) ns"
