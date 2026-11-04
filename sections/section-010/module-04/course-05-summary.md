---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Summary

This module covered the agent-side debug client and how it differs from the Cilium CLI.

- `cilium` runs on your machine and works on the cluster through the Kubernetes API. `cilium-dbg` runs inside an agent pod and works on one agent through a local socket.
- Use `kubectl exec` into the agent pod of the node you care about. `ds/cilium` picks an arbitrary pod.
- `cilium-dbg status` shows the agent's own view. `--brief` is for scripts and `--verbose` adds detail. A ready pod can still hide a failing controller.
- `cilium-dbg config` lists the runtime options. `cilium-dbg config Option=Value` changes one on that agent only, at once and temporarily. `cilium config set` writes the ConfigMap, applies to all agents and stays.
- An endpoint is the agent's record of one pod interface, with an ID that is unique per node. An identity is a number for a label set and is the same on every node.
- `cilium-dbg endpoint list` and `cilium-dbg identity list` map pods to endpoints and identities. The same facts exist as `CiliumEndpoint` and `CiliumIdentity` objects.
- `cilium-dbg service list` shows Services and backends. `cilium-dbg policy get` and `cilium-dbg bpf policy get` show the loaded policy and the policy of one endpoint.
- `cilium-dbg debuginfo` collects a report for one agent. `cilium sysdump` collects for the cluster.

<!-- astrona:playground:destroy -->
