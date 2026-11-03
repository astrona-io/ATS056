#!/usr/bin/env bash
# Guard: ipam, routing-mode and tunnel-protocol keep their starting values and the Helm release still exists.
# Passes before any action.
set -uo pipefail
fail=0
expect() {
  local key="$1" want="$2" got
  got="$(kubectl -n kube-system get configmap cilium-config -o "jsonpath={.data.${key}}" 2>/dev/null)"
  if [ "$got" != "$want" ]; then
    echo "FAIL: cilium-config key $key is '$got', expected '$want'"
    fail=1
  fi
}
expect ipam cluster-pool
expect routing-mode tunnel
expect tunnel-protocol geneve
if ! helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null | grep -q '"status":"deployed"'; then
  echo "FAIL: the Helm release cilium is not deployed"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: the other settings are unchanged"
exit "$fail"
