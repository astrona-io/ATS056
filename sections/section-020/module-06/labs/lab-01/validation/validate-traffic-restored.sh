#!/usr/bin/env bash
# Check: the shuttle pod can reach the probe Service again.
set -uo pipefail
code="$(kubectl -n starfleet exec deploy/shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}' http://probe.starfleet:9898 2>/dev/null)"
if [ "$code" != "200" ]; then
  echo "FAIL: shuttle got HTTP status '${code:-none}' from probe, expected 200"
  exit 1
fi
echo "PASS: shuttle reaches probe"
