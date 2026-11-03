#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
sleep 2
cilium config set debug true
kubectl -n kube-system rollout status daemonset/cilium --timeout=300s
kubectl -n kube-system rollout status deployment/cilium-operator --timeout=300s
