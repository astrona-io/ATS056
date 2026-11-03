---
estimated_duration: 20m
---

# Lab: Change A Setting With cilium config set

Graded lab for the module on changing Cilium configuration. The task is to turn on agent debug logging with `cilium config set` and to prove that every agent restarted with the new value.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/module-02/labs/lab-01
astrona submit -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-056-lab-010-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-debug-enabled.sh` | `cilium-config` has `debug: "true"` |
| `validate-agents-restarted.sh` | Every agent pod was created after the baseline time stored by the bootstrap in the ConfigMap `lab-baseline` |
| `validate-cilium-ready.sh` | The DaemonSet `cilium` has all agents ready and the operator is available |
| `validate-other-settings-unchanged.sh` | Guard: `ipam`, `enable-policy`, `routing-mode` and `tunnel-protocol` keep their defaults and the Helm release is deployed. It passes before any action |
