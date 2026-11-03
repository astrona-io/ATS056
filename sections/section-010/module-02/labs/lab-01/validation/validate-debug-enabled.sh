#!/usr/bin/env bash
# Check: the key debug in cilium-config is "true".
set -uo pipefail
value="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.debug}' 2>/dev/null)"
if [ "$value" != "true" ]; then
  echo "FAIL: cilium-config key debug is '$value', expected 'true'"
  exit 1
fi
echo "PASS: cilium-config has debug set to true"
