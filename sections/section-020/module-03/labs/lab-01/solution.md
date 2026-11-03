---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-03/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `no-reinstall`. It stays your guard.

## Step 1: Find the unhealthy components

```sh
cilium status
```

The summary has one line for each component. Look for the lines that do not say OK, and for the workload lines that show zero ready replicas. Then confirm with `kubectl`:

```sh
kubectl -n kube-system get deployments
```

## Step 2: Repair both components

The two Deployments were scaled to zero replicas. Scale them back to one replica and wait for the rollout:

```sh
kubectl -n kube-system scale deployment cilium-operator --replicas=1
kubectl -n kube-system scale deployment hubble-relay --replicas=1
kubectl -n kube-system rollout status deployment/cilium-operator --timeout=180s
kubectl -n kube-system rollout status deployment/hubble-relay --timeout=180s
cilium status --wait
```

A reinstall or an upgrade changes the Helm release revision, and the check `no-reinstall` rejects it. The installation was not wrong: only the replica counts were.

## Step 3: Report the live numbers

Read the ready counts, then create the report with the values you read:

```sh
kubectl -n kube-system get daemonset cilium
kubectl -n kube-system get deployments cilium-operator hubble-relay
kubectl -n starfleet create configmap status-report \
  --from-literal=agents-ready=<ready agents> \
  --from-literal=operator-ready=<ready operator replicas> \
  --from-literal=relay-ready=<ready relay replicas>
```

Submit:

```sh
astrona submit -c sections/section-020/module-03/labs/lab-01
```

## Why this works

`cilium status` reads the agent DaemonSet, the operator Deployment and the Hubble Relay Deployment through the Kubernetes API. A component with zero replicas shows as an error or a warning, and the fix is to restore the replicas. The report check reads the same live counts at grading time.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-020-03
```
