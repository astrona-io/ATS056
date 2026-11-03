---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Monitor The Status Of Cilium

After the installation, the question changes from "does it work?" to "does it still work?" A Cilium installation has several parts: an agent on every node, one or more operator replicas, the Envoy proxy and, when enabled, Hubble Relay. Each part can fail on its own, and a failed part often shows up first as a user complaint, not as an alert. The tools in this module give you a quick way to read the health of every part and a structured way to find the one that is broken.

Keep one sentence in mind for this module: **`cilium status` reads the state of the Cilium workloads from the Kubernetes API, `cilium-dbg status` asks one agent about its own health, and neither one replaces the other.** The first shows whether the workloads are present and ready. The second shows what an agent sees from the inside.

The module has three parts. **Reading cilium status** covers the output, the formats and the options for waiting. **Agent Status And Workload Health** goes from a component line to the workload object and to the agent itself, and repairs a component that has no replicas. **Hubble, Relay And Evidence** shows how to turn Hubble on and off, how to reach the relay and how to collect a sysdump.

## Learning objectives

After this module you can:

- Read the component lines and the workload lines of `cilium status`.
- Use `--wait`, `--wait-duration`, `--ignore-warnings`, `--verbose` and `-o json` for scripts and for debugging.
- Explain why the exit code of `cilium status` does not show health when you do not use `--wait`.
- Ask one agent for its status with `cilium-dbg status --verbose`.
- Find a component that has no running replicas and bring it back with `kubectl`.
- Enable and disable Hubble with `cilium hubble enable` and `cilium hubble disable`, and reach the relay with `cilium hubble port-forward`.
- Collect a sysdump for a problem that you cannot solve at once.

## Before you start

You need a working Cilium installation and the basics of Deployments, DaemonSets and `kubectl scale`. You need the `cilium` command-line tool on your machine. The `hubble` command-line tool is optional.

The playground is a two-node `kind` cluster running Kubernetes 1.35, with Cilium 1.20.3 and Hubble Relay installed by Helm. The example workloads run in it:

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | DaemonSet `cilium` | The agents |
| `kube-system` | DaemonSet `cilium-envoy` | The Envoy proxy on every node |
| `kube-system` | Deployment `cilium-operator` | The operator |
| `kube-system` | Deployment `hubble-relay` | The relay for Hubble flow data |
| `starfleet` | Deployments `probe` and `shuttle` | The example application |
| `outpost` | Deployment `drifter` | A client that belongs to another team |

You will break the operator and the relay on purpose in the playground, so the cluster is not for real traffic. Launch the playground now and keep it running next to you:

<!-- astrona:playground -->

## How the parts fit together

The first part is about reading the report. The second part is about finding and fixing a failed part. The third part is about the observability layer and about evidence. A graded lab follows the second part. It starts with two broken components and asks you to find and repair them.
