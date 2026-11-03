#!/usr/bin/env bash
# Guard: Cilium is the only network plugin. No other plugin DaemonSet may exist in kube-system.
set -uo pipefail
other="$(kubectl -n kube-system get daemonset --no-headers 2>/dev/null | awk '{print $1}' | grep -E '^(kube-flannel|calico-node|weave-net|canal)' || true)"
if [ -n "$other" ]; then
  echo "FAIL: another network plugin is installed: $other"
  exit 1
fi
echo "PASS: no other network plugin DaemonSet exists"
