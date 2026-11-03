#!/usr/bin/env bash
# Check: the agent DaemonSet runs the Cilium 1.20.3 image.
set -uo pipefail
image="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.spec.template.spec.containers[?(@.name=="cilium-agent")].image}' 2>/dev/null)"
case "$image" in
  *cilium:v1.20.3*) echo "PASS: the agent runs $image" ;;
  *) echo "FAIL: the agent image is '$image', expected cilium:v1.20.3"; exit 1 ;;
esac
