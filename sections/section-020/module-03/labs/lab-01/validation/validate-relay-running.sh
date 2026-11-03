#!/usr/bin/env bash
# Check: the hubble-relay Deployment has one ready replica.
set -uo pipefail
ready="$(kubectl -n kube-system get deployment hubble-relay -o 'jsonpath={.status.readyReplicas}' 2>/dev/null)"
if [ "$ready" != "1" ]; then
  echo "FAIL: hubble-relay has '${ready:-0}' ready replicas, expected 1"
  exit 1
fi
echo "PASS: Hubble Relay is running"
