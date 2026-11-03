#!/usr/bin/env bash
# Check: one ready agent per node and an available operator.
set -uo pipefail
nodes="$(kubectl get nodes --no-headers 2>/dev/null | wc -l | tr -d ' ')"
desired="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.desiredNumberScheduled}' 2>/dev/null)"
ready="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}' 2>/dev/null)"
if [ -z "$ready" ] || [ "$ready" = "0" ] || [ "$desired" != "$nodes" ] || [ "$ready" != "$desired" ]; then
  echo "FAIL: $ready agents ready, $desired desired, $nodes nodes"
  exit 1
fi
available="$(kubectl -n kube-system get deployment cilium-operator -o 'jsonpath={.status.availableReplicas}' 2>/dev/null)"
if [ -z "$available" ] || [ "$available" = "0" ]; then
  echo "FAIL: the Cilium operator is not available"
  exit 1
fi
echo "PASS: $ready agents ready on $nodes nodes and the operator is available"
