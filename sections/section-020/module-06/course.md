---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Connectivity Test Flags And Monitor Output

The connectivity test and the monitor tools produce a lot of output. Reading it well is a skill on its own: you must know which flag produces which part, which line of the output is the verdict, and which tool to use when the test says "failed" and you need to see the packets. This module collects the flags of the connectivity test by purpose, shows how to read a run, and then goes one level lower with `cilium-dbg monitor`, which prints the events of the datapath on one node.

Keep one sentence in mind for this module: **the connectivity test tells you that a path failed, and the monitor tells you where and why a packet was dropped.** The test is a yes or no answer for a scenario. The monitor is the evidence behind a no.

The module has four parts. **A Flag Reference By Purpose** groups the flags of `cilium connectivity test`. **Reading The Output Of A Run** explains the structure of a run and its exit code. **Watching Events With cilium-dbg monitor** covers the options of the monitor. **Reading Drops And Policy Verdicts** explains the fields of a drop event, the drop reasons and the Hubble equivalent.

## Learning objectives

After this module you can:

- Pick the flags of `cilium connectivity test` for a purpose: select, scope, bound the time, produce evidence or clean up.
- Read the phases of a run, a failed scenario and the exit code.
- Run `cilium-dbg monitor` with a type filter and a filter on one endpoint.
- Read the fields of a drop event, including the reason and the two identities.
- Explain on which node a drop is reported and why.
- Find the same drop with `hubble observe`.

## Before you start

You need a working Cilium installation, the basics of Kubernetes NetworkPolicy and the earlier modules on the connectivity test and on `cilium-dbg`. Hubble Relay is optional.

The playground is a two-node `kind` cluster running Kubernetes 1.35, with Cilium 1.20.3 installed by Helm:

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | DaemonSet `cilium` | The agents |
| `starfleet` | Deployments `probe` and `shuttle` | The example application |
| `outpost` | Deployment `drifter` | A client that belongs to another team |

Launch the playground now and keep it running next to you:

<!-- astrona:playground -->

## How the parts fit together

The first two parts stay on the machine side: flags and output. The last two go to the node: events and drops. A graded lab follows the fourth part. A policy blocks traffic to `probe`, and you find the drop in the monitor before you remove the cause.
