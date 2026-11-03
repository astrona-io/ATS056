#!/usr/bin/env bash
# Guard: this lab is read-only. The Helm release must still be at revision 1 and the
# settings must still have their starting values, so the report cannot be matched by changing the cluster.
set -uo pipefail
fail=0
revision="$(helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null | grep -o '"revision":"[0-9]*"' | grep -o '[0-9]*')"
if [ "$revision" != "1" ]; then
  echo "FAIL: the Helm release cilium is at revision '$revision', expected 1 (do not change the installation)"
  fail=1
fi
policy="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.enable-policy}' 2>/dev/null)"
tunnel="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.tunnel-protocol}' 2>/dev/null)"
if [ "$policy" != "never" ] || [ "$tunnel" != "geneve" ]; then
  echo "FAIL: cilium-config was changed (enable-policy '$policy', tunnel-protocol '$tunnel')"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: the installation was only read, not changed"
exit "$fail"
