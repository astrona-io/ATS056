#!/usr/bin/env bash
# Guard: the settings the learner must not change are unchanged, and Helm was not used.
set -uo pipefail
fail=0
want() {
  local key="$1" expected="$2" got
  got="$(kubectl -n kube-system get configmap cilium-config -o "jsonpath={.data.${key}}" 2>/dev/null)"
  if [ "$got" != "$expected" ]; then
    echo "FAIL: cilium-config key $key is '$got', expected '$expected'"
    fail=1
  fi
}
want tunnel-protocol geneve
want enable-policy never
want ipam kubernetes
revision="$(helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null | grep -o '"revision":"[0-9]*"' | grep -o '[0-9]*')"
if [ "$revision" != "1" ]; then
  echo "FAIL: the Helm release cilium is at revision '$revision', expected 1 (use cilium config, not helm)"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: protected settings and the Helm release are unchanged"
exit "$fail"
