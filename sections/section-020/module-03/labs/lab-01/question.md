---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Question

Solve this question on: `terminal`

The `drifter` in `outpost` reports that flows are missing in Hubble, and a colleague saw an error in the Cilium status. Cilium and Hubble Relay were installed with Helm and ran fine yesterday. Two Cilium components are not running now.

1. Use `cilium status` to find which components are not running.
2. Bring both components back to one running replica. Do not reinstall or upgrade Cilium.
3. When everything is ready, create the ConfigMap `status-report` in the namespace `starfleet` with these data keys, each holding the number of ready replicas or ready agents that the cluster reports now: `agents-ready`, `operator-ready` and `relay-ready`.

`kubectl` and `cilium` already point at the lab cluster.
