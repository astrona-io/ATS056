---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Question

Solve this question on: `terminal`

After a change this morning, new pods on both nodes of the cluster do not get a network. Cilium 1.20.3 was installed with Helm and worked yesterday. Somebody changed the Cilium agent DaemonSet directly.

1. Use `cilium status` and `kubectl` to find out why the agent pods are not ready. Read the pod events.
2. Undo the change so that both agents run the original image again and become ready. Do not reinstall or upgrade Cilium.
3. When the agents are ready, create the ConfigMap `repair-report` in the namespace `starfleet` with these data keys: `broken-container` (the name of the container that had the problem) and `ready-agents` (the number of ready agents that the cluster reports now).

`kubectl` and `cilium` already point at the lab cluster.
