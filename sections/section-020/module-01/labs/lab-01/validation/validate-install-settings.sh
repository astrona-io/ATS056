#!/usr/bin/env bash
# Check: ipam is kubernetes, the operator has one replica, and Hubble Relay is deployed.
set -uo pipefail
fail=0
ipam="$(kubectl -n kube-system get configmap cilium-config -o 'jsonpath={.data.ipam}' 2>/dev/null)"
if [ "$ipam" != "kubernetes" ]; then
  echo "FAIL: cilium-config key ipam is '$ipam', expected 'kubernetes'"
  fail=1
fi
replicas="$(kubectl -n kube-system get deployment cilium-operator -o 'jsonpath={.spec.replicas}' 2>/dev/null)"
if [ "$replicas" != "1" ]; then
  echo "FAIL: the operator has '$replicas' replicas, expected 1"
  fail=1
fi
relay="$(kubectl -n kube-system get deployment hubble-relay -o 'jsonpath={.status.availableReplicas}' 2>/dev/null)"
if [ -z "$relay" ] || [ "$relay" = "0" ]; then
  echo "FAIL: the Deployment hubble-relay is missing or not available"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: ipam, operator replicas and Hubble Relay are as required"
exit "$fail"
