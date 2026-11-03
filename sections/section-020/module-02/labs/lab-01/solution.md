---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-02/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `cilium-still-ready`. It stays your guard.

## Step 1: Check that Cilium is ready

A connectivity test is only meaningful on a healthy installation:

```sh
cilium status --wait
```

## Step 2: Run the scoped test

Each flag matches one requirement. `--test pod-to-pod` selects tests by name with a regular expression. `--single-node` limits the run to tests that need one node. `--test-namespace ats-conn` sets the prefix of the namespace, and the CLI adds `-1`:

```sh
cilium connectivity test --single-node --test pod-to-pod --test-namespace ats-conn
```

The command deploys the test workloads, runs the tests, and prints a report with the number of successful tests. Read the report. If a test fails, read the failure text, because the check `test-workloads` only proves that the workloads exist.

## Step 3: Check the result and submit

```sh
kubectl get namespaces
kubectl -n ats-conn-1 get deployments
astrona submit -c sections/section-020/module-02/labs/lab-01
```

Do not run `cilium connectivity test --cleanup`: it removes the test workloads that the checks look for.

## Why this works

The CLI creates the test namespace and workloads itself, so the namespace name and the workload names show how the run was scoped. The default namespace is `cilium-test-1`. A run without `--single-node` would also deploy `echo-other-node`, which the check `test-scope` rejects.

Remove the lab when you are done:

```sh
astrona destroy ats-056-lab-020-02
```
