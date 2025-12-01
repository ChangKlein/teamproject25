#!/usr/bin/env bash
# Environment setup for our project

# RUN_MODE controls what to run: C_ONLY, PY_ONLY, or BOTH
export RUN_MODE="BOTH"

# LOG_LEVEL can be INFO or DEBUG (for now just informational)
export LOG_LEVEL="INFO"

# Example timeout (seconds)
export RUN_TIMEOUT=5

echo "RUN_MODE=$RUN_MODE"
echo "LOG_LEVEL=$LOG_LEVEL"
echo "RUN_TIMEOUT=$RUN_TIMEOUT"
