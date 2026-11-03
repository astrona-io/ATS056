#!/usr/bin/env bash
# Check: the Helm release cilium is deployed and its revision is higher than 1.
set -uo pipefail
json="$(helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null)"
revision="$(printf '%s' "$json" | grep -o '"revision":"[0-9]*"' | grep -o '[0-9]*')"
if ! printf '%s' "$json" | grep -q '"status":"deployed"'; then
  echo "FAIL: the Helm release cilium is not deployed"
  exit 1
fi
if [ -z "$revision" ] || [ "$revision" -lt 2 ]; then
  echo "FAIL: the Helm release cilium is at revision '${revision:-none}', expected 2 or higher (run helm upgrade)"
  exit 1
fi
echo "PASS: the release cilium is deployed at revision $revision"
