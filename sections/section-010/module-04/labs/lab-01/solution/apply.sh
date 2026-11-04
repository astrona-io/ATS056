#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
probe_pod="$(kubectl -n starfleet get pod -l app=probe -o 'jsonpath={.items[0].metadata.name}')"
node="$(kubectl -n starfleet get pod "$probe_pod" -o 'jsonpath={.spec.nodeName}')"
agent="$(kubectl -n kube-system get pods -l k8s-app=cilium --field-selector "spec.nodeName=$node" -o 'jsonpath={.items[0].metadata.name}')"
endpoint="$(kubectl -n starfleet get ciliumendpoint "$probe_pod" -o 'jsonpath={.status.id}')"
identity="$(kubectl -n starfleet get ciliumendpoint "$probe_pod" -o 'jsonpath={.status.identity.id}')"
kubectl -n starfleet create configmap agent-report \
  --from-literal=agent-pod="$agent" \
  --from-literal=endpoint-id="$endpoint" \
  --from-literal=identity-id="$identity"
