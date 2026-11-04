---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Agent Pods That Do Not Start

The agent pod is the part of Cilium that every node needs. If it does not run on a node, that node has no working pod network, and every new pod on it is stuck. The causes fall into a few groups, and each group has a state or an event that identifies it. This part goes through the groups and ends with the repair of a bad change to the DaemonSet.

## The image cannot be pulled

The state `ErrImagePull`, followed by `ImagePullBackOff`, means the container runtime on the node cannot download the image. The cause is in the events of the pod: a wrong image name or tag, a registry that the node cannot reach, or missing credentials for a private registry. The agent pod uses the image `quay.io/cilium/cilium`. In an environment without internet access, you point the chart to your own registry with the `image.repository` value.

```sh
kubectl -n kube-system describe pod <agent pod>
```

Read the `Events` section. A line that names the image and says that the pull failed identifies this group. Fix the image reference or the access to the registry. Do not delete the pod: the DaemonSet creates the same pod again and the same pull fails.

## An init container fails

Before the agent container starts, the pod runs init containers, one after another. An init container is a short-lived container that prepares the node. Cilium uses them for tasks such as mounting the BPF filesystem, applying kernel settings and installing the CNI plugin binary on the node. If one of them fails, the pod state shows `Init:` followed by an error, for example `Init:CrashLoopBackOff`, and the agent container never starts.

Read the logs of the init container by name. Take the names from the `describe` output:

```sh
kubectl -n kube-system logs <agent pod> -c <init container name>
```

Typical causes are a node that lacks a requirement, such as a kernel that is too old or missing kernel features, and a node where the container may not mount host paths. The installation prerequisites listed the kernel requirements. A failing init container on one node only, with the others healthy, points to a node difference.

## The agent crashes

When the init containers pass and the agent container starts and exits, the state is `CrashLoopBackOff`. The agent exits when it finds a configuration it cannot use or an environment it cannot work in. Read the previous logs:

```sh
kubectl -n kube-system logs <agent pod> -c cilium-agent --previous
```

The last error lines give the reason. Common reasons are a setting in `cilium-config` with a value the agent does not accept, a request for a feature that the kernel does not support, and an address or a range that conflicts with another one. After you change a setting, the agents restart and read it again, so a bad value from a recent change is a first suspect. Check the history of changes before you look elsewhere.

## The pod runs but is not ready

A pod in state `Running` with a ready count of `0/1` has a failing readiness probe. The agent reports itself as ready only when it has finished its startup work. During a normal start this takes a short time. If it lasts, the agent is waiting for something: the connection to the API server, the operator or an identity. The agent logs name what it waits for.

## The pod cannot be scheduled

The state `Pending` with an event about scheduling means no node can run the pod. For a DaemonSet this is rare, because the pod is bound to its node. It happens when a node has a taint that the agent does not tolerate, or when the node lacks the resources the pod requests. The chart adds tolerations so that the agent can run on tainted nodes, and removing them is a common mistake.

## Undoing a bad change to the DaemonSet

Sometimes the cause is a change that someone made directly to the DaemonSet, for example a new image that does not exist. Kubernetes keeps a revision history for a DaemonSet, so you can return to the previous revision:

<!-- astrona:playground:renew -->

```sh
kubectl -n kube-system rollout history daemonset/cilium
kubectl -n kube-system rollout undo daemonset/cilium
kubectl -n kube-system rollout status daemonset/cilium --timeout=180s
```

The `undo` command restores the pod template of the previous revision, and `status` waits until the rollout is complete. This is a fix in Kubernetes, below Helm. The Helm release record does not change, so Helm still believes that the release is as it installed it. That is acceptable for a quick repair of a manual mistake, and the next Helm upgrade renders the DaemonSet again from the chart. If the bad change came from Helm itself, for example from a bad value in an upgrade, use `helm rollback` instead. That returns the release record and the objects together.

## What you know and what is open

You can now identify image, init container, crash, readiness and scheduling failures from the pod state and the events, and you can undo a bad DaemonSet change. The open question is the failure that happens before any agent runs: nodes that never become ready and pods that never get an address.

## Common pitfalls

> [!WARNING]
> - **Deleting a pod that fails to pull its image.** The DaemonSet recreates it with the same image.
> - **Reading only the agent container logs.** An init container may be the failing one.
> - **Forgetting the recent change.** A bad setting or image from the last hour is the first suspect.
> - **Fixing with `kubectl` and forgetting Helm.** The next Helm upgrade renders the chart again and can bring the problem back.
