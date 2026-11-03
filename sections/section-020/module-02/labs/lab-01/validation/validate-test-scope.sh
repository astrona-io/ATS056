#!/usr/bin/env bash
# Check: the run was scoped. It used the custom namespace prefix and the single-node mode.
set -uo pipefail
fail=0
if kubectl get namespace cilium-test-1 >/dev/null 2>&1; then
  echo "FAIL: namespace cilium-test-1 exists: the run did not use --test-namespace ats-conn"
  fail=1
fi
if kubectl -n ats-conn-1 get deployment echo-other-node >/dev/null 2>&1; then
  echo "FAIL: Deployment echo-other-node exists in ats-conn-1: the run did not use --single-node"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: the run used the custom namespace and the single-node mode"
exit "$fail"
