---
estimated_duration: 25m
---

# Lab: Find A Policy Drop With The Monitor

Graded lab for the module on connectivity test flags and monitor output. Cilium is installed with example workloads, and a NetworkPolicy denies all ingress traffic to `probe`. The task is to read the drop in `cilium-dbg monitor`, report it and remove the cause.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-06/labs/lab-01
astrona submit -c sections/section-020/module-06/labs/lab-01
astrona destroy ats-056-lab-020-06
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-drop-report.sh` | `drop-report` holds the reason `Policy denied` and the destination `probe` |
| `validate-policy-removed.sh` | The NetworkPolicy `probe-deny` is gone |
| `validate-traffic-restored.sh` | `shuttle` gets HTTP 200 from `probe` |
| `validate-no-reinstall.sh` | Guard: Helm revision 1 and all agents ready. It passes before any action |
