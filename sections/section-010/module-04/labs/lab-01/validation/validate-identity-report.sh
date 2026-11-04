#!/usr/bin/env bash
# Check: the ConfigMap agent-report holds the security identity of the probe pod.
set -uo pipefail
probe_pod="$(kubectl -n starfleet get pod -l app=probe -o 'jsonpath={.items[0].metadata.name}' 2>/dev/null)"
want="$(kubectl -n starfleet get ciliumendpoint "$probe_pod" -o 'jsonpath={.status.identity.id}' 2>/dev/null)"
got="$(kubectl -n starfleet get configmap agent-report -o 'jsonpath={.data.identity-id}' 2>/dev/null)"
if [ -z "$want" ] || [ "$got" != "$want" ]; then
  echo "FAIL: identity-id in agent-report is '$got' but the identity of probe is '$want'"
  exit 1
fi
echo "PASS: agent-report holds the identity of probe"
