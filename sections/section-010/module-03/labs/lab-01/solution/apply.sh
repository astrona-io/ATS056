#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
sleep 2
kubectl -n starfleet create configmap datapath-report \
  --from-literal=ipam=cluster-pool \
  --from-literal=routing-mode=tunnel \
  --from-literal=tunnel-protocol=geneve \
  --from-literal=enable-policy=never
cilium config set enable-policy default
kubectl -n kube-system rollout status daemonset/cilium --timeout=300s
kubectl -n kube-system rollout status deployment/cilium-operator --timeout=300s
