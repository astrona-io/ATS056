---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Summary

This module covered how to read the health of a Cilium installation and how to find a failed component.

- `cilium status` reads the Cilium workloads from the Kubernetes API and builds a summary of components, workload counts, container states and image versions.
- A plain `cilium status` does not fail on an unhealthy cluster. `--wait` makes it wait for a clean state and fail when the time ends, and `--wait-duration` sets the limit.
- `--ignore-warnings` accepts warnings but not errors. `-o json` is for scripts, and `--verbose` adds detail to messages.
- A component line maps to one workload in `kube-system`: DaemonSets for the agent and Envoy, Deployments for the operator and the relay.
- A Deployment scaled to zero has no pods to inspect. Read the desired and ready counts, and scale it back with `kubectl`.
- `cilium-dbg status --verbose` in an agent pod shows what the agent itself sees. `cilium features status` shows which features are enabled.
- `cilium hubble enable` and `cilium hubble disable` change Hubble through the release. `cilium hubble port-forward` opens a local path to the relay.
- `hubble observe` shows flows with verdicts. The flow buffer is limited.
- `cilium sysdump` collects logs, status and configuration into one archive. Review it before sharing.
- Decide in order: status, workload counts, pods, agent, flows, sysdump.

<!-- astrona:playground:destroy -->
