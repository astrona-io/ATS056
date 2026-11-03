---
estimated_duration: 20m
---

# Lab: Report The Effective Cilium Configuration

Graded lab for the module on reading Cilium state. The cluster runs Cilium 1.20.3 with non-default settings. The task is to read the settings and the agent facts with the Cilium CLI and report them.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/module-01/labs/lab-01
astrona submit -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-056-lab-010-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-report-complete.sh` | The ConfigMap `cilium-report` has all six keys |
| `validate-config-values-match.sh` | `ipam`, `routing-mode`, `enable-policy` and `tunnel-protocol` equal the live `cilium-config` |
| `validate-agent-count-and-version.sh` | `agent-count` equals the number of agent pods and `cilium-version` equals the agent image tag without `v` |
| `validate-cluster-unchanged.sh` | Guard: Helm revision is still 1 and the settings are unchanged. It passes before any action and fails if the learner changes the cluster |
