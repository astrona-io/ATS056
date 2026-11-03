---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Question

Solve this question on: `terminal`

A new cluster for the `starfleet` namespace was built without a network plugin. Its nodes are not ready and no pod can get an address. Install Cilium so the cluster works.

1. Install Cilium with the Cilium command-line tool. Use Cilium version `1.20.3`, set the IPAM mode to `kubernetes`, run one replica of the Cilium operator and deploy Hubble Relay.
2. Wait until `cilium status` reports success: every node must have a ready agent and the operator must be available.
3. All nodes must be `Ready` and the CoreDNS Deployment must be available.
4. Do not install any other network plugin.

`kubectl` and `cilium` already point at the lab cluster.
