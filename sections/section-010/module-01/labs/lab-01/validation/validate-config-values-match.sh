#!/usr/bin/env bash
# Check: the four configuration values in the report equal the live cilium-config ConfigMap.
set -uo pipefail
fail=0
for key in ipam routing-mode enable-policy tunnel-protocol; do
  live="$(kubectl -n kube-system get configmap cilium-config -o "jsonpath={.data.${key}}" 2>/dev/null)"
  reported="$(kubectl -n starfleet get configmap cilium-report -o "jsonpath={.data.${key}}" 2>/dev/null)"
  if [ -z "$reported" ] || [ "$reported" != "$live" ]; then
    echo "FAIL: $key in cilium-report is '$reported' but cilium-config has '$live'"
    fail=1
  fi
done
[ "$fail" -eq 0 ] && echo "PASS: the reported configuration values match cilium-config"
exit "$fail"
