#!/usr/bin/env bash
# Guard: only debug may change. Other settings keep their starting values and the Helm release still exists.
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
expect ipam kubernetes
expect enable-policy default
expect routing-mode tunnel
expect tunnel-protocol vxlan
if ! helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null | grep -q '"status":"deployed"'; then
  echo "FAIL: the Helm release cilium is not deployed"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: the other settings are unchanged"
exit "$fail"
