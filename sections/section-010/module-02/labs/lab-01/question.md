---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Question

Solve this question on: `terminal`

The `shuttle` in `starfleet` sometimes loses a request, and the platform team needs more detail from the Cilium agents. Cilium is installed and healthy. The agents log at the normal level.

1. Turn on debug logging for the Cilium agents by setting the key `debug` to `true` in the agent configuration. Use the Cilium command-line tool.
2. Make sure every Cilium agent pod runs with the new value. The agents read their configuration only when they start.
3. Leave the cluster healthy: all agents must be ready and the Cilium operator must be available when you finish.
4. Change nothing else. Do not reinstall Cilium, and do not delete the ConfigMap `lab-baseline` in `kube-system`: the check uses it to find out when the lab started.

`kubectl` and `cilium` already point at the lab cluster.
