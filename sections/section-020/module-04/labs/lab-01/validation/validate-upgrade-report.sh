#!/usr/bin/env bash
# Check: the ConfigMap upgrade-report in starfleet holds the live revision and the chart version.
set -uo pipefail
if ! kubectl -n starfleet get configmap upgrade-report >/dev/null 2>&1; then
  echo "FAIL: ConfigMap upgrade-report does not exist in namespace starfleet"
  exit 1
fi
json="$(helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null)"
revision="$(printf '%s' "$json" | grep -o '"revision":"[0-9]*"' | grep -o '[0-9]*')"
chart="$(printf '%s' "$json" | grep -o '"chart":"[^"]*"' | cut -d'"' -f4)"
fail=0
check_key() {
  local key="$1" want="$2" got
  got="$(kubectl -n starfleet get configmap upgrade-report -o "jsonpath={.data.${key}}" 2>/dev/null)"
  if [ -z "$want" ] || [ "$got" != "$want" ]; then
    echo "FAIL: $key in upgrade-report is '$got' but the live value is '$want'"
    fail=1
  fi
}
check_key revision "$revision"
check_key chart "$chart"
[ "$fail" -eq 0 ] && echo "PASS: upgrade-report matches the live release"
exit "$fail"
