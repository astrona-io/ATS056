---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/module-04/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `no-reinstall`. It stays your guard.

## Step 1: Find the agent on the node of probe

```sh
kubectl -n starfleet get pods -l app=probe -o wide
kubectl -n kube-system get pods -l k8s-app=cilium -o wide
```

Read the node name of the `probe` pod, then find the agent pod with the same node name. This is the agent that knows the pod.

## Step 2: Read the endpoint and the identity

```sh
kubectl -n kube-system exec <agent pod> -c cilium-agent -- cilium-dbg endpoint list
```

Find the row whose labels include `k8s:app=probe`. The first column is the endpoint ID and the identity column holds the identity number. Confirm the identity in the identity table:

```sh
kubectl -n kube-system exec <agent pod> -c cilium-agent -- cilium-dbg identity list
```

## Step 3: Report

```sh
kubectl -n starfleet create configmap agent-report \
  --from-literal=agent-pod=<agent pod> \
  --from-literal=endpoint-id=<endpoint id> \
  --from-literal=identity-id=<identity>
```

Submit:

```sh
astrona submit -c sections/section-010/module-04/labs/lab-01
```

## Why this works

The agent keeps a table of the endpoints on its own node, so only the agent on the node of `probe` lists it. The checks read the same facts from the `CiliumEndpoint` object of the pod.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-010-04
```
