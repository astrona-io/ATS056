#!/usr/bin/env bash
# Check: every agent pod is ready and the agent container uses the Cilium 1.20.3 image again.
set -uo pipefail
desired="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.desiredNumberScheduled}' 2>/dev/null)"
ready="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}' 2>/dev/null)"
if [ -z "$desired" ] || [ "$desired" = "0" ] || [ "$desired" != "$ready" ]; then
  echo "FAIL: agents ready $ready of $desired"
  exit 1
fi
image="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.spec.template.spec.containers[?(@.name=="cilium-agent")].image}' 2>/dev/null)"
case "$image" in
  *v1.20.3*) ;;
  *) echo "FAIL: the cilium-agent container uses '$image', expected a v1.20.3 image"; exit 1 ;;
esac
echo "PASS: all agents are ready on the v1.20.3 image"
