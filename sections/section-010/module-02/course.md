---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Modify The Cilium Configuration

The Cilium command-line tool can change a setting in one command: `cilium config set debug true`. The command is short, but it does several things at once. It patches a ConfigMap, it deletes pods, and it leaves the Helm release as it was. If you do not know these three effects, you can change a setting and still not know whether the change is active, whether it is safe, or whether it will survive the next upgrade.

Keep one sentence in mind for this module: **`cilium config set` edits the ConfigMap and restarts the pods; it never edits the Helm values.** Everything in the module follows from this sentence: how to verify a change, how to apply a change without the restart, how to remove a key, and why a permanent change belongs in the Helm values.

The module has three parts. **What cilium config set Does** shows the patch that the command sends and the restart that follows it. **Deleting Keys And Controlling The Restart** covers `cilium config delete` and the flag `--restart=false`, and the way to restart the pods yourself. **Who Owns The Setting** compares a ConfigMap edit with a Helm change and shows how to carry a change through an upgrade.

## Learning objectives

After this module you can:

- Change one setting with `cilium config set` and verify that every agent runs with it.
- Explain what the command sends to the Kubernetes API and which pods it restarts.
- Remove a key with `cilium config delete` and say what the agent does without the key.
- Apply several changes with one restart by using `--restart=false`, then restart the agents yourself.
- Explain why a ConfigMap edit and the Helm values can disagree, and what that means for the next upgrade.
- Choose between a ConfigMap edit and a Helm upgrade for a given change.

## Before you start

You need to read the configuration first: the ConfigMap `cilium-config`, the Helm values and the way an agent holds its settings. You need `kubectl`, `helm` and `cilium` on your machine and the basic commands for pods, DaemonSets and rollouts.

The playground is a two-node `kind` cluster running Kubernetes 1.35, with Cilium 1.20.3 installed by Helm with default settings. These objects exist:

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | ConfigMap `cilium-config` | The configuration that you change |
| `kube-system` | DaemonSet `cilium` | The agents, one pod on every node |
| `kube-system` | Deployment `cilium-operator` | The operator |
| `starfleet` | Deployments `probe` and `shuttle` | The example application |
| `outpost` | Deployment `drifter` | A client that belongs to another team |

Changing a setting restarts the Cilium pods. The example pods keep running. Launch the playground now and keep it running next to you:

<!-- astrona:playground -->

## How the parts fit together

The first part is about the action: what the command does, step by step. The second part is about control: how to remove a key and how to decide when the restart happens. The third part is about ownership: who has the final say over a value when both a person and Helm manage it. A graded lab follows the first part. It asks you to change one setting and prove that all the agents run with it.
