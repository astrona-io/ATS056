---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Question

Solve this question on: `terminal`

The `starfleet` team runs Cilium on a cluster that was installed with Helm. Before a debugging session the platform team wants a record of the current configuration and a more detailed agent log.

1. Read the live values of the keys `tunnel-protocol`, `enable-policy` and `ipam` from the Cilium configuration, and read the version of the running Cilium agent.
2. Create the ConfigMap `config-audit` in the namespace `starfleet` with these data keys: `tunnel-protocol`, `enable-policy` and `ipam` holding the live values, and `agent-version` holding the image tag of the agent, for example `v1.20.3`.
3. Enable debug logging in the Cilium agent configuration.
4. Set the monitor aggregation level to `maximum`.
5. Make sure every agent runs with the new settings and all agents are ready.
6. Use the Cilium CLI to change the configuration. Do not run `helm upgrade`, and do not change any other setting.

`kubectl`, `helm` and `cilium` already point at the lab cluster.
