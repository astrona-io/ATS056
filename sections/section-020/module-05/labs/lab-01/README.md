---
estimated_duration: 25m
---

# Lab: Repair A Broken Cilium Agent Rollout

Graded lab for the module on troubleshooting an installation. Cilium is installed, then the agent DaemonSet is changed to an image that does not exist. The task is to find the cause from the pod events, undo the change and report the result.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-05/labs/lab-01
astrona submit -c sections/section-020/module-05/labs/lab-01
astrona destroy ats-056-lab-020-05
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-agents-recovered.sh` | All agents are ready and the `cilium-agent` container uses a v1.20.3 image |
| `validate-repair-report.sh` | `repair-report` names `cilium-agent` and the live ready count |
| `validate-no-reinstall.sh` | Guard: Helm revision 1. It passes before any action |
