---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Query The Cilium Configuration

A Cilium installation has one configuration, but you can read it in four places: the Helm values that were used to install it, the ConfigMap that the chart renders from those values, the settings that each running agent holds in memory, and the feature report that the agents give back. When a cluster behaves in an unexpected way, the first job is to find out which of these four places says what, and whether they agree. This module teaches you to read all four with the `cilium` command-line tool and with `kubectl`.

Keep one sentence in mind for this module: **the Helm values are what was asked for, the `cilium-config` ConfigMap is what the chart produced, and the agent reports what it is running now.** A mistake in the first two does not change the third until the agent restarts, and a command that reads only one place can give a wrong answer.

The module has three parts. **Where The Configuration Lives** follows a value from the Helm chart to the ConfigMap and reads it with `cilium config view`. **Effective State And Features** compares the ConfigMap with what one agent reports and reads the version, the status and the feature list. **Context, Permissions And Evidence** shows how the CLI finds the cluster and the installation, which Kubernetes permissions it needs, and how to collect a `sysdump` that holds everything for a support case.

## Learning objectives

After this module you can:

- Name the four places where Cilium configuration can be read and say what each one proves.
- Read the whole configuration with `cilium config view` and find a setting by its ConfigMap key.
- Map the common Helm values (`ipam.mode`, `policyEnforcementMode`, `tunnelProtocol`, `routingMode`, `debug.enabled`) to their ConfigMap keys.
- Compare the ConfigMap with the effective configuration of one agent and explain a difference.
- Read the client and server versions with `cilium version` and the enabled features with `cilium features status`.
- Select the cluster, the namespace and the Helm release name for the CLI with flags and environment variables.
- Collect a `sysdump` and say what it contains.

## Before you start

You need the Kubernetes basics: pods, DaemonSets, Deployments, ConfigMaps and namespaces, and the commands `kubectl get`, `kubectl describe` and `kubectl exec`. You need a working `cilium` command-line tool on your machine. You do not need to know how Cilium works inside; the parts explain what they use.

The playground is a two-node `kind` cluster running Kubernetes 1.35. It starts without a network plugin, and the start script installs Cilium 1.20.3 with Helm. Two settings differ from the defaults on purpose, so you can see them in the output: policy enforcement is `never` and the tunnel protocol is `geneve`. These workloads run in it:

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | DaemonSet `cilium` | The Cilium agent, one pod on every node |
| `kube-system` | DaemonSet `cilium-envoy` | The Envoy proxy that handles Layer 7 traffic, one pod on every node |
| `kube-system` | Deployment `cilium-operator` | The operator, which does the cluster-wide work |
| `kube-system` | ConfigMap `cilium-config` | The configuration that the agents and the operator read |
| `starfleet` | Deployments `probe` and `shuttle` | The example application: an HTTP server and a client |
| `outpost` | Deployment `drifter` | A client that belongs to another team |

`kubectl`, `helm` and `cilium` on your machine already point at the playground cluster. Launch the playground now and keep it running next to you while you read the parts:

<!-- astrona:playground -->

## How the parts fit together

The first part is about reading: it shows where each value is stored and how a Helm value becomes a ConfigMap key. The second part is about trust: it shows when a stored value is not the value that an agent uses. The third part is about reach: it shows which cluster and which installation the commands talk to, and what to collect when you must hand the evidence to someone else.

Each part ends with a short list of mistakes that waste time in practice. A graded lab follows the part that teaches its skill. It asks you to read the live configuration and write down what you found.
