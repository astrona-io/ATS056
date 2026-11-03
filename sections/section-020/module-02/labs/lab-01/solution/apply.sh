#!/usr/bin/env bash
# Reference solution, applied by `astrona test` only.
set -euo pipefail
cilium connectivity test --single-node --test pod-to-pod --test-namespace ats-conn
