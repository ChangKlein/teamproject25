#!/usr/bin/env bash
# Test runner script
# - Takes input files from tests/inputs/*.in
# - Runs both the C program (build/example)
# - And the Python program (src/example.py)
# - Saves results into tests/outputs/

set -e

BUILD_DIR="build"
INPUT_DIR="tests/inputs"
OUTPUT_DIR="tests/outputs"
LOG_DIR="logs"

mkdir -p "$OUTPUT_DIR" "$LOG_DIR"

TEST_LOG="$LOG_DIR/test.log"
: > "$TEST_LOG"

C_PROG="$BUILD_DIR/example"
PY_PROG="src/example.py"

echo "[INFO] Running tests..." | tee -a "$TEST_LOG"

for input in "$INPUT_DIR"/*.in; do
    name=$(basename "$input" .in)
    echo "[TEST] Input file: $input" | tee -a "$TEST_LOG"

    # Run C program
    if [ -x "$C_PROG" ]; then
        out_c="$OUTPUT_DIR/${name}_c.out"
        echo "  [C] Running $C_PROG < $input" | tee -a "$TEST_LOG"
        "$C_PROG" < "$input" > "$out_c"
    fi

    # Run Python program
    if [ -f "$PY_PROG" ]; then
        out_py="$OUTPUT_DIR/${name}_py.out"
        echo "  [PY] Running python3 $PY_PROG < $input" | tee -a "$TEST_LOG"
        python3 "$PY_PROG" < "$input" > "$out_py"
    fi
done

echo "[INFO] Tests finished" | tee -a "$TEST_LOG"
