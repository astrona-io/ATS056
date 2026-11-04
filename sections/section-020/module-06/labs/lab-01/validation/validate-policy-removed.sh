#!/usr/bin/env bash
# Check: the NetworkPolicy probe-deny is gone.
set -uo pipefail
if kubectl -n starfleet get networkpolicy probe-deny >/dev/null 2>&1; then
  echo "FAIL: NetworkPolicy probe-deny still exists in namespace starfleet"
  exit 1
fi
echo "PASS: the NetworkPolicy probe-deny is removed"
