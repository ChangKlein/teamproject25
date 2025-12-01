#!/usr/bin/env bash
# Log system info and analyze existing logs with grep/awk/find

set -e

LOG_DIR="logs"
mkdir -p "$LOG_DIR"

SYS_LOG="$LOG_DIR/system.log"
ANALYSIS_LOG="$LOG_DIR/analysis.log"

: > "$SYS_LOG"
: > "$ANALYSIS_LOG"

echo "[INFO] System logging started at $(date)" | tee -a "$SYS_LOG"

echo "===== ps -ef =====" >> "$SYS_LOG"
ps -ef >> "$SYS_LOG"

echo "===== netstat -tnlp =====" >> "$SYS_LOG"
netstat -tnlp >> "$SYS_LOG" 2>/dev/null || echo "[WARN] netstat not available" >> "$SYS_LOG"

echo "[INFO] Analyzing logs..." | tee -a "$ANALYSIS_LOG"

# Example: find error-like lines in all .log files
grep -iE "fail|error|warn" "$LOG_DIR"/*.log 2>/dev/null >> "$ANALYSIS_LOG" || \
    echo "No error-like lines found." >> "$ANALYSIS_LOG"

# Example: count how many [C] lines in build.log
if [ -f "$LOG_DIR/build.log" ]; then
    echo -n "[ANALYSIS] Number of C build lines: " >> "$ANALYSIS_LOG"
    awk '/\[C\]/ {count++} END {print count+0}' "$LOG_DIR/build.log" >> "$ANALYSIS_LOG"
fi

# Example: list all log files and their modification time
find "$LOG_DIR" -type f -name "*.log" -printf "%f %TY-%Tm-%Td %TH:%TM\n" >> "$ANALYSIS_LOG"

echo "[INFO] Logging & analysis finished at $(date)" | tee -a "$SYS_LOG"
