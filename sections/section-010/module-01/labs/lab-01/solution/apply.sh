#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
cfg() { kubectl -n kube-system get configmap cilium-config -o "jsonpath={.data.$1}"; }
count="$(kubectl -n kube-system get pods -l k8s-app=cilium --no-headers | wc -l | tr -d ' ')"
image="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.spec.template.spec.containers[?(@.name=="cilium-agent")].image}')"
tag="${image%%@*}"; tag="${tag##*:}"
kubectl -n starfleet create configmap cilium-report \
  --from-literal=ipam="$(cfg ipam)" \
  --from-literal=routing-mode="$(cfg routing-mode)" \
  --from-literal=enable-policy="$(cfg enable-policy)" \
  --from-literal=tunnel-protocol="$(cfg tunnel-protocol)" \
  --from-literal=agent-count="$count" \
  --from-literal=cilium-version="${tag#v}"
