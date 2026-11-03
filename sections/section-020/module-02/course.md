---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Run Cilium Connectivity Tests

A Cilium installation that reports ready can still fail to carry traffic. An agent can be running while the datapath between two nodes is broken by a firewall rule, a wrong tunnel port or a kernel feature that is missing. The command `cilium connectivity test` finds such faults. It deploys its own test workloads, sends real requests between them and reports what worked. It is the standard first check after an installation and after a change to the network configuration.

Keep one sentence in mind for this module: **the connectivity test creates its own namespace and workloads, runs many small scenarios, and reports each one; its flags decide which scenarios run, where, and what is checked besides the result.** A full run takes several minutes and needs internet access for some scenarios. Most of the skill is to run only what you need.

The module has three parts. **What The Test Deploys And Checks** describes the workloads, the scenarios and the exit code. **Selecting And Scoping A Run** covers the flags that choose scenarios, nodes, namespaces and report files. **Flow Validation And Failures** explains how Hubble confirms the result and what to do when a scenario fails.

## Learning objectives

After this module you can:

- Name the workloads that a connectivity test deploys and the namespace they run in.
- Run a connectivity test, read its report and use its exit code in a script.
- Select scenarios with `--test` and a regular expression, including a skip with `!`.
- Limit a run to a single node and set a custom test namespace prefix.
- Write a JUnit report and a timeout for use in a pipeline.
- Explain flow validation, the three values of `--flow-validation` and why Hubble Relay helps.
- Collect evidence from a failed scenario and remove the test resources.

## Before you start

You need a working Cilium installation and the basics of pods, Services and namespaces. You need the `cilium` command-line tool on your machine.

The playground is a two-node `kind` cluster running Kubernetes 1.35, with Cilium 1.20.3 and Hubble Relay installed by Helm. The example workloads are running in it:

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | DaemonSet `cilium` | The agents the test checks |
| `kube-system` | Deployment `hubble-relay` | Gives the test access to the flow data of all agents |
| `starfleet` | Deployments `probe` and `shuttle` | The example application |
| `outpost` | Deployment `drifter` | A client that belongs to another team |

The test pulls its own images from public registries, so the nodes need internet access. Launch the playground now and keep it running next to you:

<!-- astrona:playground -->

## How the parts fit together

The first part shows what happens during one run. The second part shows how to make a run small and fast. The third part shows how to get certainty from a run and what to do when it fails. A graded lab follows the second part. It asks for a scoped run in a named namespace.
