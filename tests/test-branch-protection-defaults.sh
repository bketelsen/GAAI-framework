#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$SCRIPT_DIR/.gaai/core/scripts/branch-protection-setup.sh"

# Test 1: Verify the default REQUIRED_CHECKS is empty
DEFAULT=$(grep '^REQUIRED_CHECKS=' "$SCRIPT" | head -1 | cut -d'"' -f2)
if [[ -n "$DEFAULT" ]]; then
  echo "FAIL: Default REQUIRED_CHECKS should be empty, got: '$DEFAULT'"
  exit 1
fi
echo "PASS: Default REQUIRED_CHECKS is empty"

# Test 2: Verify checks_to_json_array handles empty input
# Extract the function and test it
source <(sed -n '/^checks_to_json_array/,/^}/p' "$SCRIPT")
RESULT=$(checks_to_json_array "")
if [[ "$RESULT" != "[]" ]]; then
  echo "FAIL: checks_to_json_array('') should return '[]', got: '$RESULT'"
  exit 1
fi
echo "PASS: checks_to_json_array('') returns '[]'"

# Test 3: Verify it still works with a real check name
RESULT=$(checks_to_json_array "My Check")
if [[ "$RESULT" != '["My Check"]' ]]; then
  echo "FAIL: checks_to_json_array('My Check') should return '[\"My Check\"]', got: '$RESULT'"
  exit 1
fi
echo "PASS: checks_to_json_array('My Check') works correctly"

# Test 4: Verify script --help mentions no default checks
HELP_OUTPUT=$(bash "$SCRIPT" --help 2>&1)
if echo "$HELP_OUTPUT" | grep -q 'default:.*Framework Integrity Check'; then
  echo "FAIL: --help still references 'Framework Integrity Check' as default"
  exit 1
fi
echo "PASS: --help does not reference 'Framework Integrity Check' as default"

echo ""
echo "All tests passed."
