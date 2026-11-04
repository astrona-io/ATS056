---
estimated_duration: 20m
---

# Lab: Find The Agent, Endpoint And Identity Of A Pod

Graded lab for the module on cilium-dbg. Cilium is installed with example workloads. The task is to find the agent on the node of the pod `probe`, read its endpoint ID and identity with `cilium-dbg`, and report them.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/module-04/labs/lab-01
astrona submit -c sections/section-010/module-04/labs/lab-01
astrona destroy ats-056-lab-010-04
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-agent-pod-report.sh` | `agent-pod` is the agent pod on the node of `probe` |
| `validate-endpoint-id-report.sh` | `endpoint-id` is the endpoint ID of `probe` |
| `validate-identity-report.sh` | `identity-id` is the identity of `probe` |
| `validate-no-reinstall.sh` | Guard: Helm revision 1 and all agents ready. It passes before any action |
