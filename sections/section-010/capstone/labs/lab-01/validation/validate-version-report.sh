#!/usr/bin/env bash
# Check: config-audit key agent-version holds the version tag of the running agent image.
set -uo pipefail
image="$(kubectl -n kube-system get daemonset cilium -o 'jsonpath={.spec.template.spec.containers[?(@.name=="cilium-agent")].image}' 2>/dev/null)"
want="$(echo "$image" | sed -E 's#^.*:(v[0-9][^@]*)(@.*)?$#\1#')"
got="$(kubectl -n starfleet get configmap config-audit -o 'jsonpath={.data.agent-version}' 2>/dev/null)"
if [ -z "$want" ] || [ "$got" != "$want" ]; then
  echo "FAIL: agent-version in config-audit is '$got', the agent image tag is '$want'"
  exit 1
fi
echo "PASS: agent-version is $want"
