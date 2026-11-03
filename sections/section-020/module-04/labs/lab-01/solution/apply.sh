#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
sleep 2
helm repo add cilium https://helm.cilium.io/ --force-update
helm repo update
helm upgrade cilium cilium/cilium --version 1.20.3 --namespace kube-system \
  --reuse-values --set hubble.relay.enabled=true --wait --timeout 300s
kubectl -n kube-system rollout status deployment/hubble-relay --timeout=300s
revision="$(helm list -n kube-system --filter '^cilium$' -o json | grep -o '"revision":"[0-9]*"' | grep -o '[0-9]*')"
chart="$(helm list -n kube-system --filter '^cilium$' -o json | grep -o '"chart":"[^"]*"' | cut -d'"' -f4)"
kubectl -n starfleet create configmap upgrade-report --from-literal=revision="$revision" --from-literal=chart="$chart"
