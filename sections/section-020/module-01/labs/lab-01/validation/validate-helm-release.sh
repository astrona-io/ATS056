#!/usr/bin/env bash
# Check: a Helm release named cilium is deployed in kube-system with chart version 1.20.3.
set -uo pipefail
out="$(helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null)"
if ! echo "$out" | grep -q '"status":"deployed"'; then
  echo "FAIL: no deployed Helm release named cilium in kube-system"
  exit 1
fi
if ! echo "$out" | grep -q '"chart":"cilium-1.20.3"'; then
  echo "FAIL: the release does not use chart cilium-1.20.3"
  exit 1
fi
echo "PASS: Helm release cilium 1.20.3 is deployed"
