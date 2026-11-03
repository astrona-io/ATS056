---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Summary

`cilium install` is a Helm install of the Cilium chart. It downloads the chart for a version, merges your values with the chart defaults and stores the result as a Helm release named `cilium` in `kube-system`. A cluster without a network plugin shows `NotReady` nodes and pending CoreDNS pods until the agent writes the CNI configuration on each node.

## What you learned

Cilium needs a Linux kernel of 5.10 or newer on every node, no other network plugin, access to the images and the chart, and an identity that can create cluster-wide objects. The chart creates the DaemonSets `cilium` and `cilium-envoy`, the Deployment `cilium-operator`, the ConfigMap `cilium-config` and the service accounts and roles that they need. It creates no CRDs, and it adds Hubble Relay only when `hubble.relay.enabled` is set. The IPAM mode `kubernetes` uses the pod CIDR of each node, and the chart default `cluster-pool` lets the operator hand out ranges.

The command takes a pinned version with `--version`, Helm values with `--set`, `--set-string`, `--set-file` and `--values`, and a chart source with `--repository` and `--chart-directory`. The default version belongs to the client, so a pinned version makes the result repeatable. `--dry-run-helm-values` prints the values that differ from the chart defaults, and `--dry-run` prints the full rendered resources. Value names are the Helm names, such as `ipam.mode`, not the ConfigMap keys.

The proof of an installation is a deployed Helm release with the chart version you chose, an agent image with the same tag, one ready agent per node, ready nodes, an available CoreDNS and `cilium status --wait` without errors and warnings. `cilium upgrade` changes the release with the same flags and keeps the earlier values by default. `cilium uninstall` removes the release and the connectivity test namespace, but it leaves the CNI configuration on the nodes unless `cni.uninstall` was enabled.

The key facts to remember are these:

- Always state `--version`. The default depends on your client.
- Preview with `--dry-run-helm-values` before you install or upgrade.
- Prove an installation with several facts, not with the exit code of one command.
- An uninstall does not give back a clean node.

<!-- astrona:playground:destroy -->
