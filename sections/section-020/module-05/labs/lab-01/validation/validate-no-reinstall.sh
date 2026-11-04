#!/usr/bin/env bash
# Guard: the repair is a DaemonSet rollback. The Helm release is still at revision 1.
set -uo pipefail
revision="$(helm list -n kube-system --filter '^cilium$' -o json 2>/dev/null | grep -o '"revision":"[0-9]*"' | grep -o '[0-9]*')"
if [ "$revision" != "1" ]; then
  echo "FAIL: the Helm release cilium is at revision '$revision', expected 1 (do not reinstall or upgrade)"
  exit 1
fi
echo "PASS: the Helm release is still at revision 1"
