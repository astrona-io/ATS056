#!/usr/bin/env bash
# Guard: there is one Helm release named cilium in kube-system and the agents are ready. Passes before any action.
set -uo pipefail
count="$(helm list -n kube-system -o json 2>/dev/null | grep -o '"name":"cilium"' | wc -l | tr -d ' ')"
if [ "$count" != "1" ]; then
  echo "FAIL: expected one Helm release named cilium in kube-system, found $count"
  exit 1
fi
desired="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.desiredNumberScheduled}' 2>/dev/null)"
ready="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}' 2>/dev/null)"
if [ -z "$desired" ] || [ "$desired" = "0" ] || [ "$desired" != "$ready" ]; then
  echo "FAIL: agents ready $ready of $desired"
  exit 1
fi
echo "PASS: one Helm release cilium exists and the agents are ready"
