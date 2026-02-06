#!/bin/bash
# Run all SDD plugin tests and report results
set -uo pipefail

TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL_PASS=0
TOTAL_FAIL=0
FAILED_SUITES=""

for test_file in "$TEST_DIR"/test-*.sh; do
  [ -f "$test_file" ] || continue
  test_name=$(basename "$test_file" .sh)

  echo ""
  echo "================================================================"
  echo "Running: $test_name"
  echo "================================================================"

  output=$(bash "$test_file" 2>&1)
  exit_code=$?
  echo "$output"

  # Parse results from output
  results_line=$(echo "$output" | grep "^=== Results:" | tail -1)
  if [ -n "$results_line" ]; then
    suite_pass=$(echo "$results_line" | grep -oP '\d+ passed' | grep -oP '\d+')
    suite_fail=$(echo "$results_line" | grep -oP '\d+ failed' | grep -oP '\d+')
    TOTAL_PASS=$((TOTAL_PASS + ${suite_pass:-0}))
    TOTAL_FAIL=$((TOTAL_FAIL + ${suite_fail:-0}))
  fi

  if [ "$exit_code" -ne 0 ]; then
    FAILED_SUITES="$FAILED_SUITES $test_name"
  fi
done

echo ""
echo "================================================================"
echo "TOTAL RESULTS: $TOTAL_PASS passed, $TOTAL_FAIL failed"
echo "================================================================"

if [ "$TOTAL_FAIL" -gt 0 ]; then
  echo "FAILED SUITES:$FAILED_SUITES"
  exit 1
else
  echo "ALL TESTS PASSED"
  exit 0
fi
