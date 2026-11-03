---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/capstone/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `single-network-plugin`. It stays your guard.

## Step 1: Install and wait

```sh
cilium install --version 1.20.3 --set ipam.mode=kubernetes --set operator.replicas=1 --set hubble.relay.enabled=true --wait
cilium status --wait
```

Pin the version with `--version`. Each CLI release has its own default version, and a different default makes the check `agent-image` fail.

## Step 2: Run the scoped connectivity test

```sh
cilium connectivity test --single-node --test pod-to-pod --test-namespace ats-conn
```

`--test` selects tests by name, `--single-node` keeps the run to tests that need one node, and `--test-namespace ats-conn` makes the CLI use the namespace `ats-conn-1`. Read the report at the end of the run. Do not use `--cleanup`: it removes what the checks look for.

## Step 3: Record the status

Read the live counts, then create the report:

```sh
kubectl -n kube-system get daemonset cilium
kubectl -n kube-system get deployments cilium-operator hubble-relay
kubectl -n starfleet create configmap install-report \
  --from-literal=agents-ready=<ready agents> \
  --from-literal=operator-ready=<ready operator replicas> \
  --from-literal=relay-ready=<ready relay replicas>
```

Submit:

```sh
astrona submit -c sections/section-020/capstone/labs/lab-01
```

## Why this works

The install check reads the Helm release and the agent image, because the CLI installs Cilium as a Helm release. The test checks read the namespace and workload names that the CLI creates, which show how the run was scoped. The report check reads the same live counts at grading time.

Remove the lab when you are done:

```sh
astrona destroy ats-056-cap-020
```
