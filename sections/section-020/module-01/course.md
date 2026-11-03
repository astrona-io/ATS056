---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Install Cilium With The CLI

A Kubernetes cluster needs a network plugin before its pods can start. Without one, the nodes report `NotReady`, the system pods that need a pod network stay pending, and no application can run. Cilium is such a plugin. The Cilium command-line tool installs it with one command, and the command is a thin layer over Helm. If you know what the command renders, which options it accepts and how to check the result, you can install Cilium on a new cluster, repeat the installation on another one, and find out why an installation failed.

Keep one sentence in mind for this module: **`cilium install` is a Helm install of the Cilium chart, with a pinned version and your values.** Every flag you use is either a Helm value in disguise or an option for how the tool waits.

The module has three parts. **Prerequisites And What Gets Installed** lists what the cluster must provide and which objects the chart creates. **Install Options And Values** covers the version, the `--set` flags, the values file and the dry-run flags. **Verify, Upgrade And Uninstall** shows how to prove the installation, how an upgrade differs from an install, and how to remove Cilium.

## Learning objectives

After this module you can:

- List the cluster requirements for Cilium: kernel, network plugin state, image access and permissions.
- Name the workloads that the chart creates and what each one does.
- Install a pinned Cilium version with `cilium install --version` and set values with `--set` and `--values`.
- Preview an installation with `--dry-run` and `--dry-run-helm-values`, and list the available versions.
- Confirm a working installation with `cilium status --wait`, the Helm release, the node state and CoreDNS.
- Upgrade an installation with `cilium upgrade` and remove it with `cilium uninstall`.

## Before you start

You need Kubernetes basics: nodes, DaemonSets, Deployments, namespaces and the commands `kubectl get` and `kubectl describe`. You need `helm` and the `cilium` command-line tool on your machine.

The playground is a two-node `kind` cluster running Kubernetes 1.35. It starts without a network plugin: the nodes are `NotReady` and the CoreDNS pods are pending. Only the namespaces `starfleet` and `outpost` exist. You install Cilium yourself.

| Namespace | Object | State at the start |
| --- | --- | --- |
| all | nodes | `NotReady`, because no network plugin runs |
| `kube-system` | Deployment `coredns` | Pods pending, because no pod network exists |
| `starfleet`, `outpost` | namespaces | Empty. They hold the example workloads in later work |

The cluster downloads the Cilium images from a public registry, so its nodes need internet access. Launch the playground now and keep it running next to you:

<!-- astrona:playground -->

## How the parts fit together

The first part explains the problem and the result: what a node needs and what the chart adds. The second part is the command: how you choose the version and the settings. The third part is the proof: how you know the installation works, and how you change or remove it later. A graded lab follows the third part. It starts from the same empty cluster and asks for a complete installation.
