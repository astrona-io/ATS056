#!/usr/bin/env bash
# Check: the ConfigMap cilium-report exists in starfleet and every required key has a value.
set -uo pipefail
fail=0
if ! kubectl -n starfleet get configmap cilium-report >/dev/null 2>&1; then
  echo "FAIL: ConfigMap cilium-report does not exist in namespace starfleet"
  exit 1
fi
for key in ipam routing-mode enable-policy tunnel-protocol agent-count cilium-version; do
  value="$(kubectl -n starfleet get configmap cilium-report -o "jsonpath={.data.${key}}" 2>/dev/null)"
  if [ -z "$value" ]; then
    echo "FAIL: key $key is missing or empty in cilium-report"
    fail=1
  fi
done
[ "$fail" -eq 0 ] && echo "PASS: cilium-report has all six keys"
exit "$fail"
