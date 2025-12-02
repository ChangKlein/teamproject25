#!/usr/bin/env bash
# Run tests differently for test1 and test2
# test1 -> run C only
# test2 -> run Python only

set -e

TEST_DIR="tests/inputs"
OUT_DIR="tests/outputs"
BUILD_DIR="build"

mkdir -p "$OUT_DIR"

echo "[INFO] Running tests..."

for infile in "$TEST_DIR"/*.in; do
    name=$(basename "$infile" .in)

    echo "[TEST] Input file: $infile"

    if [ "$name" = "test1" ]; then
        # C ONLY
        outfile="$OUT_DIR/${name}_c.out"
        echo "  [C] Running $BUILD_DIR/example < $infile"
        "$BUILD_DIR/example" < "$infile" > "$outfile"
        echo "  [C] Output saved to $outfile"
    fi

    if [ "$name" = "test2" ]; then
        # Python ONLY
        outfile="$OUT_DIR/${name}_py.out"
        echo "  [PY] Running python3 src/example.py < $infile"
        python3 src/example.py < "$infile" > "$outfile"
        echo "  [PY] Output saved to $outfile"
    fi
done

echo "[INFO] Tests finished"
