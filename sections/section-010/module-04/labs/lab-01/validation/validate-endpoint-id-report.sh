#!/usr/bin/env bash
# Check: the ConfigMap agent-report holds the endpoint ID that Cilium gave to the probe pod.
set -uo pipefail
probe_pod="$(kubectl -n starfleet get pod -l app=probe -o 'jsonpath={.items[0].metadata.name}' 2>/dev/null)"
want="$(kubectl -n starfleet get ciliumendpoint "$probe_pod" -o 'jsonpath={.status.id}' 2>/dev/null)"
got="$(kubectl -n starfleet get configmap agent-report -o 'jsonpath={.data.endpoint-id}' 2>/dev/null)"
if [ -z "$want" ] || [ "$got" != "$want" ]; then
  echo "FAIL: endpoint-id in agent-report is '$got' but the endpoint ID of probe is '$want'"
  exit 1
fi
echo "PASS: agent-report holds the endpoint ID of probe"
