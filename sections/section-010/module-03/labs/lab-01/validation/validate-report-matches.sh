#!/usr/bin/env bash
# Check: the ConfigMap datapath-report in starfleet holds the starting values of the four settings.
set -uo pipefail
if ! kubectl -n starfleet get configmap datapath-report >/dev/null 2>&1; then
  echo "FAIL: the ConfigMap datapath-report does not exist in the namespace starfleet"
  exit 1
fi
fail=0
check() {
  local key="$1" want="$2" got
  got="$(kubectl -n starfleet get configmap datapath-report -o "jsonpath={.data.${key}}" 2>/dev/null)"
  if [ "$got" != "$want" ]; then
    echo "FAIL: datapath-report key $key is '$got', expected '$want'"
    fail=1
  fi
}
check ipam cluster-pool
check routing-mode tunnel
check tunnel-protocol geneve
check enable-policy never
[ "$fail" -eq 0 ] && echo "PASS: the report holds the starting values"
exit "$fail"
