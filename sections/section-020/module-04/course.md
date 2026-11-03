---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Install And Upgrade Cilium With Helm

The Cilium command-line tool installs Cilium, but under the surface the work is done by Helm. The tool packs the Cilium Helm chart, renders it and stores the result as a Helm release. Many production clusters skip the tool and use Helm directly, in a pipeline that applies a values file. To install, upgrade and repair Cilium with confidence, you need to know the Helm side: the repository, the release, the values and the history.

Keep one sentence in mind for this module: **a Cilium installation is a Helm release, so every change to it is a revision that you can list, compare and roll back.** The release records the values that you chose. The values decide what the chart creates. The history lets you return to an earlier revision.

The module has four parts. **Repository, Chart And Release** installs Cilium with Helm and shows what the release owns. **Values And Their Precedence** covers `--set`, values files and the three reuse options. **Upgrade, History And Rollback** covers the safe upgrade order and the way back. **Helm And The Cilium CLI** explains how the two tools share one release and how to uninstall without leftovers.

## Learning objectives

After this module you can:

- Add the Cilium chart repository, list the chart versions and install a chosen version.
- Name the objects that the chart creates and the objects that the operator creates later.
- Explain how Helm combines chart defaults, values files and `--set` options.
- Choose between `--reuse-values`, `--reset-values` and `--reset-then-reuse-values`.
- Upgrade a release one minor version at a time, check it and roll it back.
- Explain why `cilium install` and `helm install` must not both own the same installation.

## Before you start

You need a running Kubernetes cluster, `kubectl`, `helm` and the `cilium` command-line tool on your machine, and the idea of a Helm release. The playground is a two-node `kind` cluster running Kubernetes 1.35, with Cilium 1.20.3 installed by Helm. These objects exist:

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | Helm release `cilium` | The installation, at revision 1 |
| `kube-system` | DaemonSet `cilium` | The agents |
| `kube-system` | Deployment `cilium-operator` | The operator |
| `starfleet` | Deployments `probe` and `shuttle` | The example application |
| `outpost` | Deployment `drifter` | A client that belongs to another team |

Launch the playground now and keep it running next to you:

<!-- astrona:playground -->

## How the parts fit together

The first part reads the release that exists. The second part explains where its values come from. The third part changes the release and returns to an earlier state. The fourth part places the Cilium command-line tool next to Helm. A graded lab follows the second part. It asks you to add Hubble Relay with `helm upgrade` and to keep every earlier value.
