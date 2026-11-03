#!/usr/bin/env bash
# Check: the key enable-policy in cilium-config is "default".
set -uo pipefail
value="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.enable-policy}' 2>/dev/null)"
if [ "$value" != "default" ]; then
  echo "FAIL: cilium-config key enable-policy is '$value', expected 'default'"
  exit 1
fi
echo "PASS: cilium-config has enable-policy set to default"
