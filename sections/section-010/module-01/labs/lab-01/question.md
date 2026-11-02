---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Read Effective Agent Configuration

Read the effective IPAM, routing and policy settings.

## Starting state

Cilium manages the private two-node cluster. Hubble Relay and the BGP control plane are enabled. The probe and two clients are healthy; no learner policy or evidence report exists. This baseline uses kube-proxy and tunnelling.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-056-lab-010-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-056-lab-010-01-01" || exit 1
node_name="astro-ats-056-lab-010-01-01-control-plane"
worker_name="astro-ats-056-lab-010-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Inspect the ConfigMap used by agent Pods instead of assuming CLI defaults are current cluster state. Record exactly ipam, routing-mode and enable-policy.

Record observations in `starfleet/evidence`, whose `report.json` contains the stated report. The verifier reads the live API again; invented values do not pass.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
