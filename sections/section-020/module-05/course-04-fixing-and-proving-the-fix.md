---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Fixing And Proving The Fix

Finding the cause is half of the work. The other half is to repair it in the right layer, to show that the repair worked, and to leave evidence. This part covers the three repair tools, the commands that prove health, and the sysdump for problems that stay open.

## Choose the layer of the repair

A Cilium installation made with Helm has three layers, and each has its own undo.

- The Kubernetes objects, such as the DaemonSet or a Deployment. Use `kubectl scale` for a replica count and `kubectl rollout undo` for a bad change to a template.
- The Helm release. Use `helm rollback` to return to an earlier revision when the bad change came from `helm upgrade`. Use a corrected `helm upgrade` with the right values when the values were wrong.
- The Cilium configuration. Use `cilium config set` or `cilium config delete` for a key in `cilium-config`, remembering that the next Helm upgrade can overwrite it.

Pick the lowest layer that holds the mistake and the highest that you can keep. A mistake made with `kubectl set image` is repaired with `kubectl rollout undo`. A mistake made with `helm upgrade` is repaired with `helm rollback`.

The commands `cilium install` and `cilium uninstall` are the last resort. Uninstall removes the networking from the cluster, and existing pods lose connectivity until the new installation is ready. Use them on a lab cluster, not as a repair on a cluster with traffic.

## Prove the result

A repair is done when the status is clean and the workloads agree. Use the wait form of the status command:

<!-- astrona:playground:renew -->

```sh
cilium status --wait --wait-duration 3m
```

The command ends with success only when no error and no warning remains. If it times out, the output names the component that is still unhealthy, and you go back to the five questions.

A clean status does not prove that pods can talk to each other. For that, run a scoped connectivity test, for example the scenario for pod-to-pod traffic on a single node:

```sh
cilium connectivity test --single-node --test pod-to-pod
```

A passing run proves that a pod can reach another pod through the repaired datapath. The test creates its own namespace and test pods, and it should run on a cluster where you can accept that.

## Check the nodes and the pods

After a repair of the agents, also check that the cluster state matches:

```sh
kubectl get nodes
kubectl get pods -A -o wide
```

All nodes must be `Ready`. Pods that were stuck in `ContainerCreating` start on their own once the agent works, because the kubelet retries. Pods that were already running keep running during the repair, but a new pod during an agent outage waits.

## When you cannot fix it

If the cause stays unknown, collect evidence before you change more, because later changes overwrite the state:

```sh
cilium sysdump
```

The sysdump gathers the status, the configuration, the logs of the Cilium pods and the Kubernetes objects of all nodes into one archive. Write down the Cilium version, the Kubernetes version, the kernel version and what you changed last. Review the archive before you send it, because it contains addresses and configuration.

## What you know

You can now choose the layer of a repair, undo a bad change, prove the result with `cilium status --wait` and a connectivity test, and collect evidence. You have a method for the failures that this module covered: the failing component, the failing pod, the failing process and the node without a network.

## Common pitfalls

> [!WARNING]
> - **Reinstalling as a first reaction.** It removes the evidence and can bring the same fault back.
> - **Declaring success after `cilium status` alone.** Run a connectivity test to prove traffic.
> - **Mixing layers.** Do not repair a Helm mistake with `kubectl` and leave the release record wrong.
> - **Changing more before collecting a sysdump.** Collect first, then change.
