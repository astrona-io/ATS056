---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Question

Solve this question on: `terminal`

The crew of the `bridge` is about to review the network of the `starfleet` namespace. Before the review, the platform team needs a written record of how Cilium is set up in this cluster. Cilium is already installed. Do not change the installation: this task only reads.

Create the ConfigMap `cilium-report` in the namespace `starfleet`. It must have exactly these data keys, and each value must be what the cluster reports now:

1. `ipam`, `routing-mode`, `enable-policy` and `tunnel-protocol`: the values of these four keys in the Cilium agent configuration.
2. `agent-count`: the number of Cilium agent pods that run in the cluster.
3. `cilium-version`: the version of the Cilium agent, written without the leading `v` (for example `1.2.3`).

The cluster was installed with settings that are not the defaults. Read the values from the cluster instead of assuming them. Do not run `cilium config set`, `cilium upgrade` or `helm upgrade`: a check fails if the installation was changed.

`kubectl` and `cilium` already point at the lab cluster.
