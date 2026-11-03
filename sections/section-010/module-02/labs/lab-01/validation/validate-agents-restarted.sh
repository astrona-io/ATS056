#!/usr/bin/env bash
# Check: every agent pod was created after the lab became ready, so every agent runs with the new setting.
set -uo pipefail
to_epoch() {
  date -u -d "$1" +%s 2>/dev/null || date -u -j -f "%Y-%m-%dT%H:%M:%SZ" "$1" +%s 2>/dev/null
}
baseline="$(kubectl -n kube-system get configmap lab-baseline -o 'jsonpath={.data.epoch}' 2>/dev/null)"
if [ -z "$baseline" ]; then
  echo "FAIL: the lab baseline is missing (do not delete the ConfigMap lab-baseline)"
  exit 1
fi
fail=0
count=0
for stamp in $(kubectl -n kube-system get pods -l k8s-app=cilium -o 'jsonpath={.items[*].metadata.creationTimestamp}' 2>/dev/null); do
  count=$((count + 1))
  created="$(to_epoch "$stamp")"
  if [ -z "$created" ] || [ "$created" -le "$baseline" ]; then
    echo "FAIL: an agent pod created at $stamp is older than the lab start, so it still runs the old configuration"
    fail=1
  fi
done
if [ "$count" -eq 0 ]; then
  echo "FAIL: no Cilium agent pods found"
  exit 1
fi
[ "$fail" -eq 0 ] && echo "PASS: all $count agent pods were created after the change"
exit "$fail"
