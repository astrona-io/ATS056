#!/usr/bin/env bash
# Check: debug is "true" and monitor-aggregation is "maximum" in cilium-config.
set -uo pipefail
fail=0
debug="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.debug}' 2>/dev/null)"
if [ "$debug" != "true" ]; then
  echo "FAIL: cilium-config key debug is '$debug', expected 'true'"
  fail=1
fi
agg="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.monitor-aggregation}' 2>/dev/null)"
if [ "$agg" != "maximum" ]; then
  echo "FAIL: cilium-config key monitor-aggregation is '$agg', expected 'maximum'"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: debug and monitor-aggregation are set"
exit "$fail"
