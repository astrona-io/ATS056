---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Values And Their Precedence

A Helm values file is the record of every decision about an installation. The chart has hundreds of default values, and you change a few of them. Helm merges the defaults with your values in a fixed order. When you upgrade, a second question appears: which values does the new revision start from? A wrong answer silently returns settings to their defaults.

## The three sources and their order

Helm builds the final values from three sources. Later sources override earlier ones:

1. The default values that ship with the chart.
2. Values files that you pass with `-f` or `--values`. When you pass several files, the later file wins.
3. Single values that you pass with `--set`. A `--set` value beats every file.

Read the defaults of the chart, and the values of the release in the playground:

<!-- astrona:playground:renew -->

```sh
helm show values cilium/cilium --version 1.20.3 | head -40
helm get values cilium -n kube-system
```

The second command prints only the values that were set by the user, which here are `ipam.mode` and `operator.replicas`. Add `--all` to see the merged values, including every default.

## Writing values in a file

A file is better than a long line of `--set` options, because you can keep it in version control and review it. Save this as `values-cilium.yaml`:

```yaml
ipam:
  mode: kubernetes
operator:
  replicas: 1
hubble:
  relay:
    enabled: true
```

Use it in an upgrade:

```sh
helm upgrade cilium cilium/cilium --version 1.20.3 --namespace kube-system -f values-cilium.yaml
```

This command sets exactly the values of the file on top of the chart defaults. Any value that was set earlier with `--set` and is not in the file goes back to its default. That is the correct behaviour when the file is the single source of truth.

## The three reuse options

When you do not pass a file with every earlier value, you must tell Helm what to do with the values of the previous revision:

- `--reuse-values` starts from the values of the last release, and applies your new `--set` and `-f` values on top. The risk: it also reuses the old chart defaults, so a value that the new chart added is missing and the new chart can fail to render.
- `--reset-values` ignores the last release and starts from the chart defaults of the new chart. Earlier user values are lost unless you pass them again.
- `--reset-then-reuse-values` resets to the defaults of the new chart, then applies the user values of the last release, then your new values. It needs Helm 3.14 or newer, and it is the safest choice for a chart upgrade without a file.

The Cilium upgrade guide recommends saving the values before an upgrade:

```sh
helm get values cilium -n kube-system -o yaml > values-before-upgrade.yaml
```

With that file, an upgrade has a clear input and the three options do not matter.

## Values that matter for Cilium

Some values change the installation fundamentally. The `ipam.mode` value chooses the IPAM mode. The `kubeProxyReplacement` value turns on the eBPF Service handling. When it is on and there is no `kube-proxy`, the values `k8sServiceHost` and `k8sServicePort` must give the API server address. The `operator.replicas` value sets the operator count, and 2 is the chart default, which is why a one-node cluster shows a pending operator pod. The `hubble.relay.enabled` value adds the relay.

## A dry run before the change

Render the result without applying it. The output shows what the chart would create:

```sh
helm upgrade cilium cilium/cilium --version 1.20.3 --namespace kube-system --reuse-values --set hubble.relay.enabled=true --dry-run
```

Read the rendered manifest for the objects that changed. Then run the command without `--dry-run`.

## What you know and what is open

You can now read and write values, explain the order of precedence and choose a reuse option. The open question is the order of an upgrade, and how to return to a revision that worked.

## Common pitfalls

> [!WARNING]
> - **Upgrading with only `--set` and no reuse option.** Helm uses the chart defaults, and earlier settings vanish.
> - **Trusting `--reuse-values` across chart versions.** New default values are missing.
> - **Reading `helm get values` and thinking it shows all values.** It shows only the values that you set. Use `--all` for the rest.
> - **Keeping the only copy of the values in your shell history.** Keep a values file in version control.
