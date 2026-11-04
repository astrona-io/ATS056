#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
kubectl -n kube-system rollout undo daemonset/cilium
kubectl -n kube-system rollout status daemonset/cilium --timeout=300s
ready="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}')"
kubectl -n starfleet create configmap repair-report \
  --from-literal=broken-container=cilium-agent \
  --from-literal=ready-agents="$ready"
