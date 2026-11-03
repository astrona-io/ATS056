---
estimated_duration: 40m
---

# Lab: Install, Test And Monitor Cilium Capstone

Capstone for the section on installing Cilium, running connectivity tests and monitoring status. The cluster starts without a network plugin. The task is to install Cilium, run a scoped connectivity test and record the monitored status. OPEN ITEM: the checks rely on the test workloads that the CLI leaves in the test namespace after a run. This must be confirmed in a first live run.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/capstone/labs/lab-01
astrona submit -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-056-cap-020
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-helm-release.sh` | A deployed Helm release `cilium` with chart `cilium-1.20.3` |
| `validate-agent-image.sh` | The agent DaemonSet image is `cilium:v1.20.3` |
| `validate-install-settings.sh` | `ipam` is `kubernetes`, the operator has 1 replica and `hubble-relay` is available |
| `validate-agents-ready.sh` | One agent per node is ready and the operator is available |
| `validate-test-namespace.sh` | The namespace `ats-conn-1` exists |
| `validate-test-scope.sh` | No `cilium-test-1` namespace and no `echo-other-node` Deployment |
| `validate-install-report.sh` | `install-report` keys equal the live ready counts |
| `validate-single-network-plugin.sh` | Guard: no second network plugin DaemonSet. It passes before any action |
