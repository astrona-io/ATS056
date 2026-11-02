---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Separate Ready Agents From Working Connectivity

Establish both deployment health and a successful service request.

The task and solution use a separate pinned kind cluster. Run `testing/smoke.sh` with its private kubeconfig to verify initial rejection and reference success. Static validation is not live evidence. Runtime verification remains pending.
