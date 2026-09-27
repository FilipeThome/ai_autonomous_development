#!/usr/bin/env bash
set -euo pipefail

TASK=""
LOG_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -Task|--task)
      TASK="${2:-}"
      shift 2
      ;;
    -LogFile|--log-file)
      LOG_FILE="${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: scripts/run_delivery.sh -Task \"task description\" [-LogFile path]" >&2
      exit 2
      ;;
  esac
done

if [[ -z "$TASK" ]]; then
  echo "Usage: scripts/run_delivery.sh -Task \"task description\" [-LogFile path]" >&2
  exit 2
fi

echo "Delivery plan for: $TASK"
echo "Gates are sequential. Start the next gate only after the current one passes."
echo "This script prints the gates. It does not launch a model."

if [[ -n "$LOG_FILE" ]]; then
  echo "0. diagnostics - analyze $LOG_FILE before editing"
fi

echo "1. architect - approve boundaries before code, except a small fix inside an existing boundary"
echo "2. implement - kotlin-engineer, java-engineer, or react-engineer. Keep existing Kotlin."
echo "3. test - run the stack test command and return failures to the implementer"
echo "4. review - reject architecture, test, or memory-rule failures"
echo "Done: build succeeds, tests passed, boundaries hold, memory updated when a new pattern appeared."
