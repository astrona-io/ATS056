#!/usr/bin/env bash
# Check: the ConfigMap drop-report holds the drop reason of the monitor and the blocked destination.
set -uo pipefail
fail=0
if ! kubectl -n starfleet get configmap drop-report >/dev/null 2>&1; then
  echo "FAIL: ConfigMap drop-report does not exist in namespace starfleet"
  exit 1
fi
reason="$(kubectl -n starfleet get configmap drop-report -o 'jsonpath={.data.drop-reason}' 2>/dev/null)"
if [ "$reason" != "Policy denied" ]; then
  echo "FAIL: drop-reason is '$reason', expected 'Policy denied'"
  fail=1
fi
dest="$(kubectl -n starfleet get configmap drop-report -o 'jsonpath={.data.blocked-destination}' 2>/dev/null)"
if [ "$dest" != "probe" ]; then
  echo "FAIL: blocked-destination is '$dest', expected 'probe'"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: drop-report names the reason and the destination"
exit "$fail"
