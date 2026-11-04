---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Troubleshoot A Cilium Installation

An installation can fail in two ways. The install command can fail at once with an error, or it can finish and leave a cluster in which pods have no network. The second case is harder because the symptom, a pod that is stuck or cannot reach another pod, is far from the cause. This module gives a fixed order for finding the cause, and shows the common causes with the commands that prove each one.

Keep one sentence in mind for this module: **work from the outside in, and let each command narrow the search: `cilium status` shows which component fails, `kubectl` shows why the pod fails, the container logs show why the process fails.** Do not skip to a reinstall. A reinstall hides the cause and often brings it back.

The module has four parts. **Reading The Failure** gives the order of commands. **Agent Pods That Do Not Start** covers image, init container and crash problems. **Nodes And Pods Without Network** covers nodes that stay not ready and pods that stay without an address. **Fixing And Proving The Fix** covers rollback, waiting for health and collecting evidence.

## Learning objectives

After this module you can:

- Follow the order status, workload, pod, events, logs when a Cilium component fails.
- Read pod events and container logs of the agent and the operator.
- Tell an image problem, a crash and a scheduling problem apart.
- Explain why a node stays `NotReady` before the agent runs, and which settings the agent needs to reach the API server.
- Undo a bad DaemonSet change with `kubectl rollout undo`, and know when to use `helm rollback` instead.
- Prove the fix with `cilium status --wait` and collect a sysdump when you cannot fix it.

## Before you start

You need the basics of pods, DaemonSets, `kubectl describe` and `kubectl logs`. The module on monitoring status explains `cilium status`; here you use it as the first step.

The playground is a two-node `kind` cluster running Kubernetes 1.35, with Cilium 1.20.3 installed by Helm and working. You will break it on purpose, so do not use it for real traffic:

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | DaemonSet `cilium` | The agents |
| `kube-system` | Deployment `cilium-operator` | The operator |
| `starfleet` | Deployments `probe` and `shuttle` | The example application |
| `outpost` | Deployment `drifter` | A client that belongs to another team |

Launch the playground now and keep it running next to you:

<!-- astrona:playground -->

## How the parts fit together

The first part is the method. The second part applies it to agent pods. A graded lab follows the second part: the agents are broken and you must find the cause and repair them. The third part covers failures that happen before the agent runs. The fourth part ends with the fix and the proof.
