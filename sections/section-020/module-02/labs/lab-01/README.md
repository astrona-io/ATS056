---
estimated_duration: 25m
---

# Lab: Run A Scoped Connectivity Test

Graded lab for the module on connectivity tests. Cilium is installed with Hubble Relay. The task is to run a scoped connectivity test and leave its namespace in place. OPEN ITEM: the checks rely on the test workloads that the CLI leaves in the namespace after a run. This must be confirmed in a first live run.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-02/labs/lab-01
astrona submit -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-056-lab-020-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-test-namespace.sh` | The namespace `ats-conn-1` exists |
| `validate-test-workloads.sh` | The Deployments `client` and `echo-same-node` in `ats-conn-1` are available |
| `validate-test-scope.sh` | No `cilium-test-1` namespace and no `echo-other-node` Deployment, so the run used `--test-namespace ats-conn` and `--single-node` |
| `validate-cilium-still-ready.sh` | Guard: all agents ready and Helm revision 1. It passes before any action |
