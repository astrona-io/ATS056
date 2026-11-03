---
estimated_duration: 20m
---

# Lab: Upgrade A Cilium Helm Release

Graded lab for the module on Helm installation and upgrade. Cilium is installed by Helm without Hubble Relay. The task is to add the relay with `helm upgrade --reuse-values`, keep the old values and report the revision and the chart.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-04/labs/lab-01
astrona submit -c sections/section-020/module-04/labs/lab-01
astrona destroy ats-056-lab-020-04
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-revision-increased.sh` | The Helm release `cilium` is deployed at revision 2 or higher |
| `validate-values-kept.sh` | The release values contain `ipam.mode=kubernetes`, `operator.replicas=1` and `hubble.relay.enabled=true` |
| `validate-relay-running.sh` | `hubble-relay` has 1 ready replica and all agents are ready |
| `validate-upgrade-report.sh` | `upgrade-report` has `revision` and `chart` equal to the live release |
| `validate-guard.sh` | Guard: one Helm release `cilium` and all agents ready. It passes before any action |
