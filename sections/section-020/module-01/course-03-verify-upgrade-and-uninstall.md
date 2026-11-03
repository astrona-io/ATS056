---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Verify, Upgrade And Uninstall

An installation command that returns without an error does not prove that the cluster works. The proof is a set of facts that you read from the cluster: the Helm release, the image version, the ready agents, the ready nodes and a running CoreDNS. This part shows how to read each fact, how an upgrade changes an installation, and what `cilium uninstall` removes and leaves behind.

## Proving the installation

Start with the tool's own report. The command `cilium status` reads the Cilium workloads through the Kubernetes API and prints one line for each component. With `--wait`, it repeats the check until the status shows no errors and no warnings, or until the time runs out:

<!-- astrona:playground:renew -->

```sh
cilium status --wait
```

The default wait is five minutes, set by `--wait-duration`. Use `--wait` right after an installation, because the agents need time to start. The command ends successfully when every component is ready. Then read the facts that the report does not give you.

The Helm release shows the chart version and the state of the release:

```sh
helm list -n kube-system
```

The row for `cilium` shows the status `deployed` and the chart `cilium-1.20.3`. A status `failed` means that Helm did not finish the installation. The agent image shows the Cilium version that runs on the nodes:

```sh
kubectl -n kube-system get daemonset cilium -o jsonpath='{.spec.template.spec.containers[?(@.name=="cilium-agent")].image}'
```

The tag of the image is the Cilium version. The three facts, release, chart and image, must give the same version. A mismatch means that the release was changed after the installation.

Then check the effects that depend on the pod network:

```sh
kubectl get nodes
kubectl -n kube-system get deployment coredns
kubectl -n kube-system get pods -o wide
```

Every node must show `Ready`. The Deployment `coredns` must show its pods as available. The `-o wide` listing shows pod addresses. Pods of the DaemonSet `cilium` use the node address, because they run with the host network. Pods of CoreDNS show addresses from the pod CIDR of their node. If the addresses come from the pod CIDR, the IPAM mode `kubernetes` works.

## When the installation does not become ready

A failed or slow installation has a short list of causes. Look at the pods first:

```sh
kubectl -n kube-system get pods
kubectl -n kube-system describe pod <cilium-agent-pod>
kubectl -n kube-system logs <cilium-agent-pod>
```

Replace `<cilium-agent-pod>` with the name of the pod that is not ready. The events in `describe` show image pull errors, scheduling problems and failed probes. The logs show why the agent stopped. These are the usual causes:

- **Image pull errors.** The node cannot reach the registry. The event says `ErrImagePull` or `ImagePullBackOff`.
- **A kernel that is too old.** The agent logs a missing kernel feature and exits.
- **Another network plugin.** The agent finds a CNI configuration that it did not write, or two plugins try to own it.
- **A missing pod CIDR.** With the mode `kubernetes`, a node without `spec.podCIDR` has no range to give to pods.
- **A pending operator replica.** On a small cluster, a second operator replica cannot be scheduled. The Deployment stays at one of two ready replicas, and `cilium status` reports a warning.

The last case is a warning and not an error. A plain `cilium status --wait` does not end while a warning exists. The flag `--ignore-warnings` lets the wait end with warnings. Use it only after you understand the warning, and not to hide a real problem.

## Upgrading

`cilium upgrade` changes an installed release. It is a Helm upgrade of the same release with the same chart repository and the same flags as the install: `--version`, `--set`, `--values`, `--dry-run`, `--dry-run-helm-values` and `--wait`. The default handling of the old values is `--reset-then-reuse-values`: the tool starts from the chart defaults, applies the values of the last release and then your new flags. Your earlier settings stay in place.

```sh
cilium upgrade --version 1.20.3 --set operator.replicas=1 --wait
```

This command keeps the version and changes one value. To move to another version, give another version. Before an upgrade to a new minor version, read the upgrade notes of that version, because some values change their meaning between releases. The agent pods are replaced by the DaemonSet update strategy, so nodes run different agent versions for a short time. Use `--dry-run-helm-values` first, so you know which values the new release would hold.

The option `--restart` forces a restart of the Cilium pods after the upgrade. Use it when a changed value only touches the ConfigMap, because Helm does not restart pods for that by itself.

## Uninstalling

`cilium uninstall` removes the Helm release and the objects it created:

```sh
cilium uninstall --wait
```

The tool also removes the namespace of the connectivity test, which has the default name `cilium-test`; the option `--test-namespace` names another one. The command waits for the removal when you give `--wait`, with a limit set by `--timeout`.

The uninstall does not touch everything. The chart value `cni.uninstall` is `false` by default, so the agent does not remove the CNI configuration file from the nodes when it stops. The file stays on the node. Pods that run keep running until they are recreated, and new pods then fail or use whatever the leftover file points to. Remove the leftover file on the nodes, or install another network plugin that overwrites it, before you rely on the cluster again. On a `kind` cluster, deleting and recreating the cluster is the cleanest way back.

## What you know

You can now install, prove and change a Cilium installation. The proof is a deployed Helm release with the version you chose, an agent image with the same tag, one ready agent per node, ready nodes, a running CoreDNS and a `cilium status` without errors. You know that an upgrade keeps the old values by default, and that an uninstall leaves the CNI configuration on the nodes.

## Common pitfalls

> [!WARNING]
> - **Calling the install done at the prompt.** Use `--wait` or `cilium status --wait`, then read the release, the image and the nodes.
> - **Using `--ignore-warnings` to make the wait end.** Read the warning first. It may name a real problem such as an unscheduled replica.
> - **Upgrading without a version.** The default version belongs to your client, and the upgrade moves the cluster to it.
> - **Using `--reset-values` on an upgrade.** It drops the values of the installation.
> - **Expecting an uninstall to leave a clean node.** The CNI configuration stays unless `cni.uninstall` was enabled before.
