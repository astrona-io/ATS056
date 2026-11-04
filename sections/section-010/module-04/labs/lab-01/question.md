---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Question

Solve this question on: `terminal`

The team that owns the `probe` Deployment in the `starfleet` namespace asks which Cilium agent serves it and how Cilium identifies it. Cilium 1.20.3 is installed. You must not change the installation.

1. Find the node that runs the `probe` pod, and the Cilium agent pod that runs on the same node.
2. In that agent pod, use `cilium-dbg` to read the endpoint ID and the security identity of the `probe` pod.
3. Create the ConfigMap `agent-report` in the namespace `starfleet` with these data keys: `agent-pod` (the name of the agent pod), `endpoint-id` and `identity-id`.

`kubectl` and `cilium` already point at the lab cluster.
