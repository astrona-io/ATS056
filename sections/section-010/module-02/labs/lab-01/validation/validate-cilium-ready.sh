#!/usr/bin/env bash
# Check: all agents are ready and the operator is available after the restart.
set -uo pipefail
desired="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.desiredNumberScheduled}' 2>/dev/null)"
ready="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}' 2>/dev/null)"
if [ -z "$desired" ] || [ "$desired" = "0" ] || [ "$desired" != "$ready" ]; then
  echo "FAIL: agents ready $ready of $desired"
  exit 1
fi
available="$(kubectl -n kube-system get deployment cilium-operator -o 'jsonpath={.status.availableReplicas}' 2>/dev/null)"
if [ -z "$available" ] || [ "$available" = "0" ]; then
  echo "FAIL: the Cilium operator has no available replica"
  exit 1
fi
echo "PASS: $ready of $desired agents are ready and the operator is available"
