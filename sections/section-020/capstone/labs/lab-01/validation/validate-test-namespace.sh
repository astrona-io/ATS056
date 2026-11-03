#!/usr/bin/env bash
# Check: the connectivity test ran in the namespace ats-conn-1 (test namespace prefix ats-conn).
set -uo pipefail
if ! kubectl get namespace ats-conn-1 >/dev/null 2>&1; then
  echo "FAIL: namespace ats-conn-1 does not exist (run the test with --test-namespace ats-conn)"
  exit 1
fi
echo "PASS: namespace ats-conn-1 exists"
