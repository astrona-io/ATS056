#!/usr/bin/env bash
# Starting state. Environment only: it must not perform any step the learner is asked to do.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export EXTRA_HELM_ARGS=""
chart_path="$(mktemp)"
trap 'rm -f "$chart_path"' EXIT
curl --fail --silent --show-error --location --max-time 120 \
  https://helm.cilium.io/cilium-1.20.3.tgz -o "$chart_path"
actual_sum="$(shasum -a 256 "$chart_path" | cut -d' ' -f1)"
if [ "$actual_sum" != "0805a5273118c436c9772bb9566d87ec558d8b25cc2ce5dc32918ecdd36f2c7c" ]; then
  echo "Chart checksum differs: $actual_sum" >&2
  exit 1
fi


helm upgrade --install cilium "$chart_path" --namespace kube-system \
  --set ipam.mode=kubernetes --set operator.replicas=1 ${EXTRA_HELM_ARGS:-} \
  --wait --timeout 300s
kubectl -n kube-system rollout status daemonset/cilium --timeout=300s
kubectl -n kube-system rollout status deployment/cilium-operator --timeout=300s
kubectl wait --for=condition=Ready nodes --all --timeout=180s

kubectl apply -f "$DIR/manifests/workloads.yaml"
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet rollout status deployment/shuttle --timeout=180s
kubectl -n outpost rollout status deployment/drifter --timeout=180s

# Record when the lab became ready. The learner's change must restart the agents after this time.
kubectl -n kube-system create configmap lab-baseline --from-literal=epoch="$(date +%s)"
echo "[lab] Ready."
