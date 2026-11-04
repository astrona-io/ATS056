---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Inspect An Agent With cilium-dbg

The `cilium` command on your machine talks to the Kubernetes API. It reads Kubernetes objects and changes them. It cannot show what one agent holds in memory: the endpoints on its node, the numeric identities, the load-balancing tables and the runtime options. For that, each agent pod contains a second tool, `cilium-dbg`, which talks to the agent on its own node through a local socket.

Keep one sentence in mind for this module: **`cilium` works on the cluster through the API server, and `cilium-dbg` works on one agent, on one node, and shows what that agent sees now.** The two tools answer different questions. A competent operator uses both and knows which one to reach for.

The module has four parts. **Reaching The Agent Debug Client** shows how to run `cilium-dbg` in an agent pod and how to pick the right pod. **Agent Status And Runtime Options** covers `cilium-dbg status` and `cilium-dbg config`, including the options that you can change on a running agent without touching the ConfigMap. **Endpoints And Identities** reads the endpoint and identity tables. **Services, Policy And Debug Information** reads the service tables and the policy of an endpoint, and collects a debug report.

## Learning objectives

After this module you can:

- Run `cilium-dbg` in the agent pod of a chosen node with `kubectl exec`.
- Explain why `cilium-dbg` shows one node and `cilium` shows the cluster.
- Read `cilium-dbg status` in its brief and verbose forms.
- List and change the runtime options with `cilium-dbg config`, and explain why such a change does not survive a restart.
- Find the endpoint and the identity of a pod with `cilium-dbg endpoint list` and `cilium-dbg identity list`.
- List services and read the policy of an endpoint.

## Before you start

You need a working Cilium installation, `kubectl` access to the `kube-system` namespace and the basics of `kubectl exec`. The earlier modules of this section explain `cilium config view` and `cilium config set`; here you meet the agent-side counterpart.

The playground is a two-node `kind` cluster running Kubernetes 1.35, with Cilium 1.20.3 installed by Helm. These objects exist:

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | DaemonSet `cilium` | The agents, one pod on every node |
| `kube-system` | Deployment `cilium-operator` | The operator |
| `starfleet` | Deployments `probe` and `shuttle` | The example application |
| `outpost` | Deployment `drifter` | A client that belongs to another team |

Launch the playground now and keep it running next to you:

<!-- astrona:playground -->

## How the parts fit together

The first part gets you into the agent. The second part reads the agent's health and its runtime options. The third part reads the tables that map pods to endpoints and identities. A graded lab follows the third part. It asks you to find the agent, the endpoint and the identity of one pod. The fourth part reads services and policy.
