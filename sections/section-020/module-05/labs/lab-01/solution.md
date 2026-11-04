---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-05/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `no-reinstall`. It stays your guard.

## Step 1: Find the cause

```sh
cilium status
kubectl -n kube-system get pods -l k8s-app=cilium -o wide
kubectl -n kube-system describe pod <agent pod>
```

The agent pods are not ready. In the events of the pod, a message says that the image pull failed and names an image tag that does not exist. The container that uses the image is `cilium-agent`.

## Step 2: Undo the change

The image was changed on the DaemonSet, so the DaemonSet has a new revision. Return to the previous one:

```sh
kubectl -n kube-system rollout history daemonset/cilium
kubectl -n kube-system rollout undo daemonset/cilium
kubectl -n kube-system rollout status daemonset/cilium --timeout=300s
cilium status --wait
```

A reinstall or an upgrade changes the Helm release revision, and the check `no-reinstall` rejects it.

## Step 3: Report

```sh
kubectl -n kube-system get daemonset cilium
kubectl -n starfleet create configmap repair-report \
  --from-literal=broken-container=cilium-agent \
  --from-literal=ready-agents=<ready agents>
```

Submit:

```sh
astrona submit -c sections/section-020/module-05/labs/lab-01
```

## Why this works

The DaemonSet keeps a revision for each change of its pod template. `kubectl rollout undo` restores the previous template, so the agents get the original image and start again. The checks read the DaemonSet image and the ready count at grading time.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-020-05
```
