---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Install Options And Values

The simplest installation is `cilium install` with no arguments. It works, and it hides three decisions: which Cilium version you get, which settings the chart uses, and whether the command waits for the result. In a real cluster you make these decisions on purpose and write them down. This part shows the options of `cilium install` and uses its two dry-run flags to look at the result before anything changes.

## What the command does

`cilium install` is a Helm install. The tool finds the chart for the version that you choose, downloads it from the chart repository, merges your values with the chart defaults, renders the templates and creates the objects in the cluster. It stores the result as a Helm release named `cilium` in the namespace `kube-system`. All of this happens in your terminal with the Helm library. No component runs in the cluster to do it.

Because of this, every setting of the chart is available to you, and the same installation can be done with `helm install` and the same values. The tool adds a pinned default version, a check of the cluster and an option to wait.

## Choosing the version

The tool has a default version, which belongs to the release of the `cilium` client. The help of the client in this course shows the default `v1.20.3`. A different release of the client has a different default. To stop the result from depending on the client on your machine, always state the version:

<!-- astrona:playground:renew -->

```sh
cilium install --list-versions
cilium install --version 1.20.3 --dry-run-helm-values
```

The first command lists the versions that the tool can install, and it does not change the cluster. The second command prints the Helm values that differ from the chart defaults and installs nothing. The tool also detects facts about the cluster, so its output can hold values that you did not set yourself.

A pinned version is also a record. The agent image carries the tag of the version, and the Helm release stores the chart version. Both can be read afterwards from the cluster.

## Setting values with --set

The flag `--set` passes a Helm value on the command line. The syntax is `name=value`, and you can repeat the flag or separate pairs with commas:

```sh
cilium install --version 1.20.3 --set ipam.mode=kubernetes --set operator.replicas=1 --dry-run-helm-values
```

The output shows the values that this command would store. The name is the Helm value, in the dotted form of the chart: `ipam.mode`, not the ConfigMap key `ipam`. Three related flags exist for other value types:

- `--set-string` sets a value as a string. Use it when a number or `true` must stay text.
- `--set-file` reads the value from a file, for example a certificate.
- `--values` or `-f` reads a whole YAML file of values. It accepts a local path or a URL, and you can repeat it.

For more than two or three values, a file is easier to read and to keep in version control. Save this as `values-ats.yaml`:

```yaml
ipam:
  mode: kubernetes
operator:
  replicas: 1
hubble:
  relay:
    enabled: true
```

Then preview the result with the file:

```sh
cilium install --version 1.20.3 --values values-ats.yaml --dry-run-helm-values
```

When the same value appears in a file and in a `--set` flag, the flag wins. The order of the flags on the command line decides between two files: the last one wins. Keep the values file in the same repository as the rest of your cluster configuration, so you can repeat the installation.

## Two previews

The tool has two dry-run flags, and they answer different questions:

- `--dry-run-helm-values` prints only the values that differ from the chart defaults. It is short and shows what you decided.
- `--dry-run` prints the full rendered resources, as YAML, that the installation would create. It is long and shows what the cluster would receive.

Use the short form to check a command that you wrote. Use the long form when you need to know the exact objects, for example to review a security setting or to check an image name:

```sh
cilium install --version 1.20.3 --set operator.replicas=1 --dry-run | grep -E '^kind: (DaemonSet|Deployment)'
```

The `grep` shows the kinds of the main workloads in the rendered output. Neither flag changes the cluster.

## Datapath mode and other tool options

The flag `--datapath-mode` selects how the packets move between nodes. The values are `tunnel`, `native`, `aws-eni`, `gke`, `azure` and `aks-byocni`. The tool detects a suitable mode for common platforms when you leave it out. The mode `tunnel` encapsulates the pod traffic in the protocol that the value `tunnelProtocol` sets, and the mode `native` routes pod addresses without encapsulation and needs the network to know the pod ranges. A `kind` cluster works with the default.

A few more options of the tool matter in practice:

- `--wait` makes the command wait until the Helm install is complete. `--wait-duration` sets the longest time, and the default is five minutes.
- `--history-max` limits how many Helm revisions are stored. The default is 10.
- `--repository` and `--chart-directory` choose where the chart comes from.
- `--nodes-without-cilium` keeps Cilium off the nodes that carry the label `cilium.io/no-schedule`. Use it only when the infrastructure provides routing to those nodes.

## Running the installation

When the previews show what you intended, run the installation. Use `--wait`, so the prompt returns when Helm is done:

```sh
cilium install --version 1.20.3 --set ipam.mode=kubernetes --set operator.replicas=1 --wait
```

Helm waits until the workloads that it created are ready. That includes the agent on every node, which means the nodes must become ready during the wait. If the wait times out, the Helm release can still exist in a failed state. Look at the pods in `kube-system` to find the cause. Do not run the same install again at once. A second `cilium install` for the same release name is an error, because the release exists. Use `cilium upgrade` to change an installed release, or `cilium uninstall` to remove it first.

## What you know and what is open

You can now state the version, pass values with flags and with a file, preview an installation in two ways and run it with a wait. The open question is how to prove that the result works, and what the commands for upgrading and removing do.

## Common pitfalls

> [!WARNING]
> - **Relying on the default version.** It belongs to the client. Another machine or a newer client installs another version.
> - **Using the ConfigMap key as a value name.** `--set ipam=kubernetes` creates a value that the chart does not know. The Helm name is `ipam.mode`.
> - **Skipping the preview.** `--dry-run-helm-values` costs one command and catches a misspelled value name.
> - **Running `cilium install` twice.** The release exists, and the second command fails. Upgrade instead.
> - **Reading the end of the command as success.** Without `--wait` the command returns when Helm has created the objects, not when they are ready.
