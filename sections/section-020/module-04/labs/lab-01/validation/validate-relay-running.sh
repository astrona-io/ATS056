#!/usr/bin/env bash
# Check: the hubble-relay Deployment has one ready replica and all agents are ready.
set -uo pipefail
ready="$(kubectl -n kube-system get deployment hubble-relay -o 'jsonpath={.status.readyReplicas}' 2>/dev/null)"
if [ "$ready" != "1" ]; then
  echo "FAIL: hubble-relay has '${ready:-0}' ready replicas, expected 1"
  exit 1
fi
desired="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.desiredNumberScheduled}' 2>/dev/null)"
agents="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}' 2>/dev/null)"
if [ -z "$desired" ] || [ "$desired" = "0" ] || [ "$desired" != "$agents" ]; then
  echo "FAIL: agents ready $agents of $desired"
  exit 1
fi
echo "PASS: Hubble Relay is running and the agents are ready"
