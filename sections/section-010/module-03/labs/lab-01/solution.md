---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/module-03/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `other-settings-unchanged`. It is your guard against a wrong fix.

## Step 1: Read the four settings

```sh
cilium config view | grep -E '^(ipam|routing-mode|tunnel-protocol|enable-policy) '
```

The values are `cluster-pool`, `tunnel`, `geneve` and `never`. The installation uses the cluster pool IPAM mode, the Geneve tunnel and no policy enforcement.

## Step 2: Write the report

Create the ConfigMap with the values from step 1:

```sh
kubectl -n starfleet create configmap datapath-report \
  --from-literal=ipam=cluster-pool \
  --from-literal=routing-mode=tunnel \
  --from-literal=tunnel-protocol=geneve \
  --from-literal=enable-policy=never
```

Do this before step 3. The report holds the starting value of `enable-policy`, which is `never`.

## Step 3: Set the policy enforcement mode to default

```sh
cilium config set enable-policy default
```

The command patches the key in the ConfigMap `cilium-config` and restarts the agent and operator pods. It returns before the new pods are ready. Wait for them:

```sh
kubectl -n kube-system rollout status daemonset/cilium --timeout=300s
kubectl -n kube-system rollout status deployment/cilium-operator --timeout=300s
```

## Step 4: Check and submit

```sh
cilium config view | grep -E '^enable-policy '
cilium status --wait
astrona submit -c sections/section-010/module-03/labs/lab-01
```

All five checks pass when the report holds the starting values, `enable-policy` is `default`, every agent pod is newer than the lab baseline, all agents are ready, and the other settings did not change.

## Why this works

The key is `enable-policy`, a ConfigMap key. The Helm value that renders it is `policyEnforcementMode`. The change is made with `cilium config set`, so the Helm release does not record it. The lab accepts that on purpose, because it checks the cluster behaviour and not the Helm values.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-010-03
```
