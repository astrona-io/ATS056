#!/usr/bin/env bash
# Check: the ConfigMap agent-report names the agent pod that runs on the node of the probe pod.
set -uo pipefail
probe_pod="$(kubectl -n starfleet get pod -l app=probe -o 'jsonpath={.items[0].metadata.name}' 2>/dev/null)"
node="$(kubectl -n starfleet get pod "$probe_pod" -o 'jsonpath={.spec.nodeName}' 2>/dev/null)"
want="$(kubectl -n kube-system get pods -l k8s-app=cilium --field-selector "spec.nodeName=$node" -o 'jsonpath={.items[0].metadata.name}' 2>/dev/null)"
got="$(kubectl -n starfleet get configmap agent-report -o 'jsonpath={.data.agent-pod}' 2>/dev/null)"
if [ -z "$want" ] || [ "$got" != "$want" ]; then
  echo "FAIL: agent-pod in agent-report is '$got' but the agent on the node of probe is '$want'"
  exit 1
fi
echo "PASS: agent-report names the agent on the node of probe"
