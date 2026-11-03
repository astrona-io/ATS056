#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
cilium install --version 1.20.3 --set ipam.mode=kubernetes --set operator.replicas=1 --set hubble.relay.enabled=true --wait
cilium status --wait
kubectl -n kube-system rollout status deployment/coredns --timeout=180s
