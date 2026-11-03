#!/usr/bin/env bash
# Check: the Cilium operator Deployment has one ready replica.
set -uo pipefail
ready="$(kubectl -n kube-system get deployment cilium-operator -o 'jsonpath={.status.readyReplicas}' 2>/dev/null)"
if [ "$ready" != "1" ]; then
  echo "FAIL: cilium-operator has '${ready:-0}' ready replicas, expected 1"
  exit 1
fi
echo "PASS: the Cilium operator is running"
