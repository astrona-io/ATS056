#!/usr/bin/env bash
# Guard: the fix is scaling. The Helm release is still at revision 1 and the agents are untouched and ready.
set -uo pipefail
revision="$(helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null | grep -o '"revision":"[0-9]*"' | grep -o '[0-9]*')"
if [ "$revision" != "1" ]; then
  echo "FAIL: the Helm release cilium is at revision '$revision', expected 1 (do not reinstall or upgrade)"
  exit 1
fi
desired="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.desiredNumberScheduled}' 2>/dev/null)"
ready="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.status.numberReady}' 2>/dev/null)"
if [ -z "$desired" ] || [ "$desired" = "0" ] || [ "$desired" != "$ready" ]; then
  echo "FAIL: agents ready $ready of $desired"
  exit 1
fi
echo "PASS: the installation was not reinstalled and the agents are ready"
