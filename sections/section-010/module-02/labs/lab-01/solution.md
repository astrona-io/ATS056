---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/module-02/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `other-settings-unchanged`. It is your guard against a wrong fix.

## Step 1: Read the current value

Look at the key before you change it:

```sh
cilium config view
```

Find the line for `debug`. It has the value `false`.

## Step 2: Set the key

`cilium config set` patches one key in the ConfigMap `cilium-config`. It then deletes the Cilium agent pods and the Cilium operator pods so that they start again with the new value:

```sh
cilium config set debug true
```

The command returns without waiting for the new pods. Wait for them:

```sh
kubectl -n kube-system rollout status daemonset/cilium --timeout=300s
kubectl -n kube-system rollout status deployment/cilium-operator --timeout=300s
```

If you ran `cilium config set debug true --restart=false` instead, the ConfigMap changes but the old pods keep running with the old value. The check `agents-restarted` catches that. Restart the agents with `kubectl -n kube-system rollout restart daemonset/cilium`.

## Step 3: Check and submit

```sh
cilium config view
cilium status --wait
astrona submit -c sections/section-010/module-02/labs/lab-01
```

All four checks pass when `debug` is `true`, every agent pod is newer than the lab baseline, all agents are ready, and no other setting changed.

## Why this works

The agents read `cilium-config` once, at start. The key is a ConfigMap key, so the name is `debug` and not the Helm value `debug.enabled`. Because the change was made with `cilium config set`, the Helm release does not record it. The lab accepts that on purpose: it checks the cluster behaviour, not the Helm values.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-010-02
```
