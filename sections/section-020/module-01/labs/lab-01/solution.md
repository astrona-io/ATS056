---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-01/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `single-network-plugin`. It stays your guard.

## Step 1: Look at the starting state

Without a network plugin the nodes are not ready:

```sh
kubectl get nodes
kubectl -n kube-system get pods
```

Check the installable versions and the values the install would use before you change anything:

```sh
cilium install --list-versions
cilium install --version 1.20.3 --set ipam.mode=kubernetes --set operator.replicas=1 --set hubble.relay.enabled=true --dry-run-helm-values
```

The second command prints the Helm values that differ from the chart defaults and installs nothing.

## Step 2: Install

```sh
cilium install --version 1.20.3 --set ipam.mode=kubernetes --set operator.replicas=1 --set hubble.relay.enabled=true --wait
```

Pin the version with `--version`. Each CLI release has its own default version, and a different default makes the check `agent-image` fail.

## Step 3: Wait for the cluster to become healthy

```sh
cilium status --wait
kubectl get nodes
kubectl -n kube-system get pods
```

`cilium status --wait` returns when the status reports no errors and no warnings. Nodes become `Ready` after their agent runs, and CoreDNS starts after that.

Submit:

```sh
astrona submit -c sections/section-020/module-01/labs/lab-01
```

## Why this works

The CLI installs Cilium as a Helm release named `cilium` in `kube-system`. The agent on each node writes the network plugin configuration for the node, which makes the node ready. Then pods get addresses from the Kubernetes IPAM mode you set.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-020-01
```
