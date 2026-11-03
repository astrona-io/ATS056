#!/usr/bin/env bash
# Check: agent-count equals the number of cilium agent pods, cilium-version equals the agent image tag without v.
set -uo pipefail
fail=0
live_count="$(kubectl -n kube-system get pods -l k8s-app=cilium --no-headers 2>/dev/null | wc -l | tr -d ' ')"
reported_count="$(kubectl -n starfleet get configmap cilium-report -o 'jsonpath={.data.agent-count}' 2>/dev/null)"
if [ -z "$reported_count" ] || [ "$reported_count" != "$live_count" ]; then
  echo "FAIL: agent-count is '$reported_count' but $live_count agent pods exist"
  fail=1
fi
image="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.spec.template.spec.containers[?(@.name=="cilium-agent")].image}' 2>/dev/null)"
tag="${image%%@*}"
tag="${tag##*:}"
live_version="${tag#v}"
reported_version="$(kubectl -n starfleet get configmap cilium-report -o 'jsonpath={.data.cilium-version}' 2>/dev/null)"
if [ -z "$live_version" ] || [ "$reported_version" != "$live_version" ]; then
  echo "FAIL: cilium-version is '$reported_version' but the agent image tag is '$live_version'"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: agent count and version in the report are correct"
exit "$fail"
