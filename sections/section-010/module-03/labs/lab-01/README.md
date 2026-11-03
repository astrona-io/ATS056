---
estimated_duration: 20m
---

# Lab: Report And Change Datapath Settings

Graded lab for the module on core datapath settings. The task is to report the IPAM mode, the routing mode, the tunnel protocol and the policy enforcement mode, and then to set the policy enforcement mode to its default with `cilium config set`.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/module-03/labs/lab-01
astrona submit -c sections/section-010/module-03/labs/lab-01
astrona destroy ats-056-lab-010-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-report-matches.sh` | The ConfigMap `datapath-report` in `starfleet` holds `cluster-pool`, `tunnel`, `geneve` and `never` |
| `validate-enforcement-default.sh` | `cilium-config` has `enable-policy: default` |
| `validate-agents-restarted.sh` | Every agent pod was created after the baseline time stored by the bootstrap in the ConfigMap `lab-baseline` |
| `validate-cilium-ready.sh` | The DaemonSet `cilium` has all agents ready and the operator is available |
| `validate-other-settings-unchanged.sh` | Guard: `ipam`, `routing-mode` and `tunnel-protocol` keep their starting values and the Helm release is deployed. It passes before any action |
