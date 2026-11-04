#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
kubectl -n starfleet create configmap drop-report \
  --from-literal=drop-reason="Policy denied" \
  --from-literal=blocked-destination=probe
kubectl -n starfleet delete networkpolicy probe-deny
sleep 5
