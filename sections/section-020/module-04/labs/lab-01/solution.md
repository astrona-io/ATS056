---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-04/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `single-release`. It is your guard against a wrong fix.

## Step 1: Look at the release

```sh
helm list -n kube-system
helm get values cilium -n kube-system
```

The release is at revision 1. The values show `ipam.mode` and `operator.replicas`. They are the values that the upgrade must keep.

## Step 2: Upgrade the release

Add the Cilium chart repository and upgrade with `--reuse-values`, so that Helm keeps the values of revision 1:

```sh
helm repo add cilium https://helm.cilium.io/
helm repo update
helm upgrade cilium cilium/cilium --version 1.20.3 --namespace kube-system \
  --reuse-values --set hubble.relay.enabled=true --wait --timeout 300s
```

Without `--reuse-values`, Helm starts from the chart defaults and drops `ipam.mode=kubernetes`. The check `values-kept` catches that.

## Step 3: Wait for Hubble Relay

```sh
kubectl -n kube-system rollout status deployment/hubble-relay --timeout=300s
cilium status --wait
```

## Step 4: Write the report

Read the revision and the chart:

```sh
helm list -n kube-system
helm history cilium -n kube-system
```

Create the ConfigMap with the values that you read. The revision is 2 if this was your first upgrade, and the chart is `cilium-1.20.3`:

```sh
kubectl -n starfleet create configmap upgrade-report \
  --from-literal=revision=2 \
  --from-literal=chart=cilium-1.20.3
```

## Step 5: Submit

```sh
astrona submit -c sections/section-020/module-04/labs/lab-01
```

All five checks pass when the release is at revision 2 or higher, the old values and the relay value are in the release, Hubble Relay and the agents are ready, the report matches, and there is still one release.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-020-04
```
