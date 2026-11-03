#!/usr/bin/env bash
# Starting state. Environment only: it must not perform any step the learner is asked to do.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl create namespace starfleet
kubectl create namespace outpost
echo "[lab] Ready."
