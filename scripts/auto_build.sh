#!/usr/bin/env bash
# Auto build script for C and Python files
# This script scans the src/ directory, compiles C files with gcc,
# and checks Python files with python3 -m py_compile.
# All logs are written to logs/build.log.

set -e  # stop on error

SRC_DIR="src"
BUILD_DIR="build"
LOG_DIR="logs"

mkdir -p "$BUILD_DIR" "$LOG_DIR"

BUILD_LOG="$LOG_DIR/build.log"

# clear old log
: > "$BUILD_LOG"

echo "[INFO] Auto build start" | tee -a "$BUILD_LOG"
echo "[INFO] Scanning directory: $SRC_DIR" | tee -a "$BUILD_LOG"

for f in "$SRC_DIR"/*; do
    # if there is no file, skip
    [ -e "$f" ] || continue

    case "$f" in
        *.c)
            exe="$BUILD_DIR/$(basename "${f%.c}")"
            echo "[C] Compiling $f -> $exe" | tee -a "$BUILD_LOG"
            if gcc -Wall -O2 "$f" -o "$exe" >>"$BUILD_LOG" 2>&1; then
                echo "[C] SUCCESS: $exe" | tee -a "$BUILD_LOG"
            else
                echo "[C] FAIL: $f (see build.log)" | tee -a "$BUILD_LOG"
            fi
            ;;
        *.py)
            echo "[PY] Checking syntax for $f" | tee -a "$BUILD_LOG"
            if python3 -m py_compile "$f" >>"$BUILD_LOG" 2>&1; then
                echo "[PY] OK: $f" | tee -a "$BUILD_LOG"
            else
                echo "[PY] FAIL: $f (see build.log)" | tee -a "$BUILD_LOG"
            fi
            ;;
        *)
            echo "[SKIP] Not a C/Python file: $f" | tee -a "$BUILD_LOG"
            ;;
    esac
done

echo "[INFO] Auto build done" | tee -a "$BUILD_LOG"
