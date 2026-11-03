#!/usr/bin/env bash
# Check: the values of the first installation are still in the release, together with the new relay value.
set -uo pipefail
values="$(helm get values cilium -n kube-system -o json 2>/dev/null | tr -d ' \n')"
fail=0
case "$values" in *'"mode":"kubernetes"'*) ;; *) echo "FAIL: the value ipam.mode=kubernetes is missing from the release values"; fail=1;; esac
case "$values" in *'"replicas":1'*) ;; *) echo "FAIL: the value operator.replicas=1 is missing from the release values"; fail=1;; esac
case "$values" in *'"relay":{"enabled":true}'*) ;; *) echo "FAIL: the value hubble.relay.enabled=true is missing from the release values"; fail=1;; esac
[ "$fail" -eq 0 ] && echo "PASS: the release keeps the old values and has hubble.relay.enabled=true"
exit "$fail"
