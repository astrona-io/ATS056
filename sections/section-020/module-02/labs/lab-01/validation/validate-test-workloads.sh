#!/usr/bin/env bash
# Check: the test workloads of a single-node run are deployed and available in ats-conn-1.
set -uo pipefail
fail=0
for name in client echo-same-node; do
  available="$(kubectl -n ats-conn-1 get deployment "$name" -o 'jsonpath={.status.availableReplicas}' 2>/dev/null)"
  if [ -z "$available" ] || [ "$available" = "0" ]; then
    echo "FAIL: Deployment $name in ats-conn-1 is missing or not available"
    fail=1
  fi
done
[ "$fail" -eq 0 ] && echo "PASS: the test workloads are available"
exit "$fail"
