#!/usr/bin/env bash
# Check: the ConfigMap install-report in starfleet holds the live ready counts.
set -uo pipefail
if ! kubectl -n starfleet get configmap install-report >/dev/null 2>&1; then
  echo "FAIL: ConfigMap install-report does not exist in namespace starfleet"
  exit 1
fi
fail=0
agents="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}' 2>/dev/null)"
operator="$(kubectl -n kube-system get deployment cilium-operator -o 'jsonpath={.status.readyReplicas}' 2>/dev/null)"
relay="$(kubectl -n kube-system get deployment hubble-relay -o 'jsonpath={.status.readyReplicas}' 2>/dev/null)"
check_key() {
  local key="$1" want="$2" got
  got="$(kubectl -n starfleet get configmap install-report -o "jsonpath={.data.${key}}" 2>/dev/null)"
  if [ -z "$want" ] || [ "$got" != "$want" ]; then
    echo "FAIL: $key in install-report is '$got' but the live value is '$want'"
    fail=1
  fi
}
check_key agents-ready "$agents"
check_key operator-ready "$operator"
check_key relay-ready "$relay"
[ "$fail" -eq 0 ] && echo "PASS: install-report matches the live ready counts"
exit "$fail"
