---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Core Datapath Settings Of Cilium

Four settings decide how a Cilium installation hands out pod addresses, moves packets between nodes, handles Kubernetes Services and enforces network policy. They are the IPAM mode, the routing mode, kube-proxy replacement and the policy enforcement mode. You can read all four with the Cilium command-line tool, and you will be asked about them when you read or change a configuration. Some of them you can change with one command, and some of them you should never change on a running cluster without a plan.

Keep one sentence in mind for this module: **a setting is only safe to change if you know which component reads it, when it reads it and what already exists in the cluster that depends on it.** The IPAM mode is read by the operator and the agent when addresses are assigned. The routing mode is read by the agent when it builds the datapath. The policy enforcement mode is read by the agent at start.

The module has four parts. **IPAM Modes** explains where pod addresses come from. **Routing Mode And Tunnels** covers tunnel and native routing and the maximum transmission unit (MTU). **Kube-Proxy Replacement** shows how Cilium handles Services and how to check it. **Policy Enforcement And Safe Changes** covers the three enforcement modes and the rules for changing any of these settings.

## Learning objectives

After this module you can:

- Name the main IPAM modes and say which component hands out the pod address ranges in each one.
- Read the IPAM, routing, kube-proxy replacement and enforcement settings from `cilium-config` and from an agent.
- Explain the difference between tunnel routing and native routing, and the settings that native routing needs.
- Say when `k8sServiceHost` and `k8sServicePort` are required.
- Describe the effect of the policy enforcement modes `default`, `always` and `never` on an endpoint.
- Decide whether a change is a `cilium config set` change or a Helm upgrade, and what to check first.

## Before you start

You need to know how to read `cilium-config` and how `cilium config set` restarts the pods. You need `kubectl`, `helm` and `cilium` on your machine.

The playground is a two-node `kind` cluster running Kubernetes 1.35, with Cilium 1.20.3 installed by Helm. It uses the cluster pool IPAM mode, the Geneve tunnel and the enforcement mode `never`. These objects exist:

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | ConfigMap `cilium-config` | The settings that you read |
| `kube-system` | DaemonSet `cilium` | The agents, one pod on every node |
| `kube-system` | Deployment `cilium-operator` | The operator |
| `starfleet` | Deployments `probe` and `shuttle` | The example application |
| `outpost` | Deployment `drifter` | A client that belongs to another team |

Launch the playground now and keep it running next to you:

<!-- astrona:playground -->

## How the parts fit together

The first three parts each take one setting and follow it from the Helm value to the ConfigMap key and to the running agent. The fourth part adds the enforcement mode and then gives the rules for changing all four. A graded lab follows the second part. It asks you to record the starting values and to change the enforcement mode.
