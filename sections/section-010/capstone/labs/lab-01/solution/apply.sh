#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
tunnel="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.tunnel-protocol}')"
policy="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.enable-policy}')"
ipam="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.ipam}')"
image="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.spec.template.spec.containers[?(@.name=="cilium-agent")].image}')"
version="$(echo "$image" | sed -E 's#^.*:(v[0-9][^@]*)(@.*)?$#\1#')"
kubectl -n starfleet create configmap config-audit \
  --from-literal=tunnel-protocol="$tunnel" \
  --from-literal=enable-policy="$policy" \
  --from-literal=ipam="$ipam" \
  --from-literal=agent-version="$version"
cilium config set debug true
cilium config set monitor-aggregation maximum
sleep 10
kubectl -n kube-system rollout status daemonset/cilium --timeout=240s
cilium status --wait
