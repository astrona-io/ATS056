#!/usr/bin/env bash
# Check: the ConfigMap repair-report names the failing container and the live ready agent count.
set -uo pipefail
fail=0
if ! kubectl -n starfleet get configmap repair-report >/dev/null 2>&1; then
  echo "FAIL: ConfigMap repair-report does not exist in namespace starfleet"
  exit 1
fi
container="$(kubectl -n starfleet get configmap repair-report -o 'jsonpath={.data.broken-container}' 2>/dev/null)"
if [ "$container" != "cilium-agent" ]; then
  echo "FAIL: broken-container is '$container', expected 'cilium-agent'"
  fail=1
fi
want="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}' 2>/dev/null)"
got="$(kubectl -n starfleet get configmap repair-report -o 'jsonpath={.data.ready-agents}' 2>/dev/null)"
if [ -z "$want" ] || [ "$got" != "$want" ]; then
  echo "FAIL: ready-agents is '$got' but the live value is '$want'"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: repair-report matches the cluster"
exit "$fail"
