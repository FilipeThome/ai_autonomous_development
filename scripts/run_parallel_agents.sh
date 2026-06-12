#!/bin/bash

TASK="$1"
LOG_FILE="$2"

echo "Running parallel agents..."

claude run "Architect: design and approve architecture for $TASK" > architect.txt &
claude run "Backend Engineer: implement solution for $TASK" > backend.txt &
claude run "Test Engineer: generate and validate tests for $TASK" > test.txt &
claude run "Reviewer: strict review and reject weak solutions for $TASK" > review.txt &

if [ ! -z "$LOG_FILE" ]; then
  claude run "Diagnostics: analyze logs from $LOG_FILE, find root cause, fix and validate" > diagnostics.txt &
fi

wait

cat architect.txt backend.txt test.txt review.txt diagnostics.txt > final_output.txt

echo "Final output generated."