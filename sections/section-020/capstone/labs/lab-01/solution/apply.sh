#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
cilium install --version 1.20.3 --set ipam.mode=kubernetes --set operator.replicas=1 --set hubble.relay.enabled=true --wait
cilium status --wait
cilium connectivity test --single-node --test pod-to-pod --test-namespace ats-conn
agents="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}')"
operator="$(kubectl -n kube-system get deployment cilium-operator -o 'jsonpath={.status.readyReplicas}')"
relay="$(kubectl -n kube-system get deployment hubble-relay -o 'jsonpath={.status.readyReplicas}')"
kubectl -n starfleet create configmap install-report \
  --from-literal=agents-ready="$agents" \
  --from-literal=operator-ready="$operator" \
  --from-literal=relay-ready="$relay"
