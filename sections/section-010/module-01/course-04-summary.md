---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Summary

Cilium configuration can be read in four places, and each one answers a different question. The Helm values are what a person asked for at install time. The ConfigMap `cilium-config` is what the chart rendered from those values, and it is what every agent and the operator read when they start. The agent in memory is what the datapath uses now. The feature report is what the agents say is switched on.

## What you learned

`cilium config view` reads the ConfigMap through the Kubernetes API and prints every key and value. It does not ask an agent. Helm value names and ConfigMap key names differ: `ipam.mode` is the key `ipam`, `policyEnforcementMode` is `enable-policy`, `debug.enabled` is `debug`, `tunnelProtocol` is `tunnel-protocol` and `routingMode` is `routing-mode`. Replica counts and optional components, such as the operator replicas and Hubble Relay, are workload objects and have no key in the ConfigMap. `helm get values` shows only the values that differ from the chart defaults unless you add `--all`.

An agent reads the ConfigMap when it starts. A changed ConfigMap reaches an agent only after a restart, so the desired state and the effective state can differ, and they can differ from node to node. `cilium-dbg config -a`, run inside an agent pod, shows the settings that agent holds, under the option names of the agent rather than the ConfigMap keys. `cilium version` shows the client version, the versions the client knows and the version in the cluster. `cilium features status` lists the enabled features of every node.

The `cilium` tool finds the cluster like `kubectl`: from `--kubeconfig`, then `KUBECONFIG`, then the default file, with `--context` to pick a context. It assumes the namespace `kube-system` and the Helm release name `cilium`, and the flags `-n`, `--helm-release-name` and the variable `CILIUM_NAMESPACE` change that. It has no rights of its own, so Kubernetes RBAC decides which commands work. `cilium sysdump` collects logs, object descriptions, Helm values and `cilium-bugtool` output into a `.zip` file and needs `pods/exec`.

The key facts to remember are these:

- Desired state is the ConfigMap. Effective state is the agent. They meet at a restart.
- `cilium config view` reads the ConfigMap only. It never proves what an agent runs.
- Check `cilium context` before any command that changes the cluster.
- Collect the sysdump before you try a fix, and check it before you share it.

<!-- astrona:playground:destroy -->
