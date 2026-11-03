#!/usr/bin/env bash
# Guard: the test must leave Cilium healthy. All agents are ready and the Helm release is untouched.
set -uo pipefail
desired="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.desiredNumberScheduled}' 2>/dev/null)"
ready="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}' 2>/dev/null)"
if [ -z "$desired" ] || [ "$desired" = "0" ] || [ "$desired" != "$ready" ]; then
  echo "FAIL: agents ready $ready of $desired"
  exit 1
fi
revision="$(helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null | grep -o '"revision":"[0-9]*"' | grep -o '[0-9]*')"
if [ "$revision" != "1" ]; then
  echo "FAIL: the Helm release cilium is at revision '$revision', expected 1"
  exit 1
fi
echo "PASS: Cilium is healthy and unchanged"
