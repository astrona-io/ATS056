#!/usr/bin/env bash
# Check: the ConfigMap config-audit in starfleet holds the live values of three cilium-config keys.
set -uo pipefail
if ! kubectl -n starfleet get configmap config-audit >/dev/null 2>&1; then
  echo "FAIL: ConfigMap config-audit does not exist in namespace starfleet"
  exit 1
fi
fail=0
check_pair() {
  local report_key="$1" config_key="$2" want got
  want="$(kubectl -n kube-system get configmap cilium-config -o "jsonpath={.data.${config_key}}" 2>/dev/null)"
  got="$(kubectl -n starfleet get configmap config-audit -o "jsonpath={.data.${report_key}}" 2>/dev/null)"
  if [ -z "$want" ] || [ "$got" != "$want" ]; then
    echo "FAIL: $report_key in config-audit is '$got' but cilium-config $config_key is '$want'"
    fail=1
  fi
}
check_pair tunnel-protocol tunnel-protocol
check_pair enable-policy enable-policy
check_pair ipam ipam
[ "$fail" -eq 0 ] && echo "PASS: config-audit matches the live configuration"
exit "$fail"
