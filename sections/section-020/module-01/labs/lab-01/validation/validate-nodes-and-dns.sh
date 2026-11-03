#!/usr/bin/env bash
# Check: every node is Ready and CoreDNS runs. Both need a working network plugin.
set -uo pipefail
not_ready="$(kubectl get nodes --no-headers 2>/dev/null | awk '$2 != "Ready" {print $1}')"
if [ -n "$not_ready" ]; then
  echo "FAIL: nodes not Ready: $not_ready"
  exit 1
fi
wanted="$(kubectl -n kube-system get deployment coredns -o 'jsonpath={.spec.replicas}' 2>/dev/null)"
have="$(kubectl -n kube-system get deployment coredns -o 'jsonpath={.status.availableReplicas}' 2>/dev/null)"
if [ -z "$have" ] || [ "$have" != "$wanted" ]; then
  echo "FAIL: CoreDNS has '$have' of '$wanted' replicas available"
  exit 1
fi
echo "PASS: all nodes are Ready and CoreDNS is available"
