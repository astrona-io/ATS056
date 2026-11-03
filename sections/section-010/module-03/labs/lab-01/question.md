---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Question

Solve this question on: `terminal`

The platform team plans a change to the network policy settings of the cluster. Before anything changes, the team wants a record of four datapath settings of the Cilium agents. Cilium is installed and healthy. The `shuttle` in `starfleet` and the `drifter` in `outpost` are running.

1. Read the current values of the keys `ipam`, `routing-mode`, `tunnel-protocol` and `enable-policy` in the agent configuration.
2. Store the four values in a ConfigMap named `datapath-report` in the namespace `starfleet`. Use the key names above as the keys of the ConfigMap. Record the values as they are before you change anything.
3. Set the policy enforcement mode of the agents to the Cilium default, with the Cilium command-line tool, and make sure every agent pod runs with it.
4. Leave the cluster healthy: all agents must be ready and the Cilium operator must be available when you finish.
5. Change nothing else. Do not reinstall Cilium, and do not delete the ConfigMap `lab-baseline` in `kube-system`: the check uses it to find out when the lab started.

`kubectl` and `cilium` already point at the lab cluster.
