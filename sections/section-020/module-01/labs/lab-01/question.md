---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Separate Ready Agents From Working Connectivity

Establish both deployment health and a successful service request.

## Starting state

Cilium manages the private two-node cluster. Hubble Relay and the BGP control plane are enabled. The probe and two clients are healthy; no learner policy or evidence report exists. This baseline uses kube-proxy and tunnelling.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-056-lab-020-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-056-lab-020-01-01" || exit 1
node_name="astro-ats-056-lab-020-01-01-control-plane"
worker_name="astro-ats-056-lab-020-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Read agent readiness and make an independent service request. A ready daemonset does not establish every connectivity path; this lab checks one path, not the complete cilium connectivity test suite.

Record observations in `starfleet/evidence`, whose `report.json` contains the stated report. The verifier reads the live API again; invented values do not pass.

The report object uses these fields: `desired`, `ready`, `response`. Keep numeric values numeric and preserve arrays and nested objects returned by the API.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
