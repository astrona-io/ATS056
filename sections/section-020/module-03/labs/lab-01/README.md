---
estimated_duration: 20m
---

# Lab: Find And Report Unhealthy Components

Graded lab for the module on monitoring Cilium. Cilium is installed with Hubble Relay, then two components are scaled to zero. The task is to find them with `cilium status`, repair them and report the final ready counts.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-03/labs/lab-01
astrona submit -c sections/section-020/module-03/labs/lab-01
astrona destroy ats-056-lab-020-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-operator-running.sh` | `cilium-operator` has 1 ready replica |
| `validate-relay-running.sh` | `hubble-relay` has 1 ready replica |
| `validate-status-report.sh` | `status-report` keys equal the live ready counts of the agents, the operator and the relay |
| `validate-no-reinstall.sh` | Guard: Helm revision 1 and all agents ready. It passes before any action |
