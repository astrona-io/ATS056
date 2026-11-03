---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Helm And The Cilium CLI

There are two ways to manage one installation: Helm and the Cilium command-line tool. They are not independent. The tool uses the Helm library inside itself, so a `cilium install` creates a normal Helm release. This part explains the link, the rule that follows from it and how to remove Cilium cleanly.

## One release, two tools

`cilium install --version 1.20.3` renders the same chart and stores a release named `cilium` in `kube-system`. After that, `helm list` shows it, and `helm get values` shows the values that the tool chose. You can list the versions that the tool can install with:

<!-- astrona:playground:renew -->

```sh
cilium install --list-versions
```

The tool adds values of its own. It detects the cluster type, for example `kind`, and sets values to match. When you run `cilium install --dry-run-helm-values`, it prints the values it would store, which is the quickest way to see those choices.

`cilium upgrade --version 1.20.3` upgrades that release. By default it reuses the values of the earlier revision, and the flag `--reset-values` starts from the chart defaults. The release can then be changed by either tool, because both write to the same Helm history.

## The rule: one owner

The two tools write the same release, so there is no conflict, as long as both talk to the same release. A conflict starts when someone installs Cilium with one tool under another name or namespace, or applies the rendered manifest with `kubectl`. Then two objects of the same kind compete, and the older one is not removed. Keep one rule: install once, name the release `cilium` and let all changes go through `helm upgrade` or `cilium upgrade`.

A second reason to choose one tool is the record. A pipeline that applies a values file with `helm upgrade` leaves a clear trail in version control. A person who runs `cilium config set` leaves no trail in Helm. The values and the cluster then disagree, and the next upgrade removes the change.

## Which tool when

Use the Cilium command-line tool for a quick installation, a test cluster, a connectivity test and a status check. Use Helm with a values file when a pipeline owns the cluster and every change needs review. The status and the connectivity test commands work the same way for both, because they read the cluster and not the release.

## Uninstall

Two commands remove the release: `cilium uninstall` and `helm uninstall cilium -n kube-system`. Both delete the agents, the operator and the objects of the release. Pods lose their network configuration when the agent is gone, so plan this for a node pool that is drained or a cluster that you remove.

```sh
helm uninstall cilium -n kube-system
```

The uninstall leaves things behind. The CRDs that the operator created stay, because Helm did not create them. Custom resources such as network policies stay with them. The CNI configuration file on the nodes can stay too, and another network plugin that you install next can find it. Check the folder `/etc/cni/net.d` on a node before you install another plugin. Delete leftovers deliberately, and only when you are sure that no other tool uses them:

```sh
kubectl get crds | grep cilium.io
```

## What you know

You can now explain that the Cilium command-line tool and Helm share one release, name the rule that keeps them apart, and remove Cilium without surprises. The module ends here. The next step is the hands-on task, which asks you to upgrade a release and keep its values.

## Common pitfalls

> [!WARNING]
> - **Applying the output of `helm template` with `kubectl`.** Helm then does not own the objects and an upgrade cannot manage them.
> - **Installing with the tool under a different release name.** The tool and the guides then look at the wrong release.
> - **Assuming `uninstall` removes the CRDs.** It does not. Check for leftovers.
> - **Running `uninstall` on a cluster with live traffic.** Pods lose their network configuration.
