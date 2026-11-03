---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. The lab has never been run, so this walkthrough does not show command output. Read each output yourself and copy what you see.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/module-01/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes. `cluster-unchanged` passes because nothing has been changed yet. It stays your guard: it fails if you change the installation.

## Step 1: Read the four configuration values

The Cilium agents read their settings from the ConfigMap `cilium-config` in `kube-system`. The Cilium command-line tool prints that ConfigMap as sorted keys and values:

```sh
cilium config view
```

Find the lines for `ipam`, `routing-mode`, `enable-policy` and `tunnel-protocol`. Write down the exact values. You can also read one key directly:

```sh
kubectl -n kube-system get configmap cilium-config -o jsonpath='{.data.enable-policy}'
```

The installation set `policyEnforcementMode` and `tunnelProtocol` to non-default values, so a guess from the defaults fails the check `config-values-match`.

## Step 2: Count the agents and read the version

One Cilium agent pod runs on each node. List them by label and count the lines:

```sh
kubectl -n kube-system get pods -l k8s-app=cilium
cilium version
```

`cilium version` prints the client version and the versions of the Cilium agent and operator that run in the cluster. Take the agent version and remove the leading `v`.

## Step 3: Create the report

Use the values you read. Replace each `<...>` with your value:

```sh
kubectl -n starfleet create configmap cilium-report \
  --from-literal=ipam=<ipam> \
  --from-literal=routing-mode=<routing-mode> \
  --from-literal=enable-policy=<enable-policy> \
  --from-literal=tunnel-protocol=<tunnel-protocol> \
  --from-literal=agent-count=<number of agent pods> \
  --from-literal=cilium-version=<agent version without v>
```

Submit:

```sh
astrona submit -c sections/section-010/module-01/labs/lab-01
```

All four checks pass when each value equals the live state and the installation is unchanged. If `config-values-match` fails, the message names the key and both values. Compare them character by character.

## Why this works

The CLI reads the cluster through the Kubernetes API, so the values come from the live ConfigMap and the live agent pods. That is why the check compares the report with the cluster at grading time and rejects a changed cluster.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-010-01
```
