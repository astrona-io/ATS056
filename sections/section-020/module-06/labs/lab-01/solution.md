---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-06/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `no-reinstall`. It stays your guard.

## Step 1: Find the agent of the destination

```sh
kubectl -n starfleet get pods -l app=probe -o wide
kubectl -n kube-system get pods -l k8s-app=cilium -o wide
```

An ingress drop is reported on the node of the destination pod, so use the agent on the node of `probe`.

## Step 2: Watch the drop

Start the monitor in the agent pod. In a second terminal, repeat the request from `shuttle`:

```sh
kubectl -n kube-system exec <agent pod> -c cilium-agent -- cilium-dbg monitor -t drop
```

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s -m 5 http://probe.starfleet:9898
```

The monitor prints a drop event for each attempt. Read the reason in parentheses after the word drop. It says that a policy denied the packet.

## Step 3: Report and fix

```sh
kubectl -n starfleet create configmap drop-report \
  --from-literal=drop-reason="<reason text>" \
  --from-literal=blocked-destination=probe
kubectl -n starfleet get networkpolicy
kubectl -n starfleet delete networkpolicy probe-deny
```

Repeat the request from `shuttle`. It must return a response now, and the monitor must show no new drops. Submit:

```sh
astrona submit -c sections/section-020/module-06/labs/lab-01
```

## Why this works

The policy `probe-deny` selects the pod `probe` for ingress and has no rules, so no source is allowed. The datapath of the node that runs `probe` drops the packets and sends a drop event to the monitor. Removing the policy removes the enforcement for that pod.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-020-06
```
