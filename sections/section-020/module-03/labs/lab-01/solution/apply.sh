#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
kubectl -n kube-system scale deployment cilium-operator --replicas=1
kubectl -n kube-system scale deployment hubble-relay --replicas=1
kubectl -n kube-system rollout status deployment/cilium-operator --timeout=180s
kubectl -n kube-system rollout status deployment/hubble-relay --timeout=180s
agents="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}')"
operator="$(kubectl -n kube-system get deployment cilium-operator -o 'jsonpath={.status.readyReplicas}')"
relay="$(kubectl -n kube-system get deployment hubble-relay -o 'jsonpath={.status.readyReplicas}')"
kubectl -n starfleet create configmap status-report \
  --from-literal=agents-ready="$agents" \
  --from-literal=operator-ready="$operator" \
  --from-literal=relay-ready="$relay"
