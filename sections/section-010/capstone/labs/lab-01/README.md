---
estimated_duration: 30m
---

# Lab: Query And Modify The Cilium Configuration Capstone

Capstone for the section on querying and modifying the Cilium configuration. Cilium runs with a non-default tunnel protocol and policy mode. The task is to report the live configuration, change two settings with the Cilium CLI and prove that the agents run with them.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/capstone/labs/lab-01
astrona submit -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-056-cap-010
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-config-report.sh` | `config-audit` keys `tunnel-protocol`, `enable-policy` and `ipam` equal the live `cilium-config` values |
| `validate-version-report.sh` | `config-audit` key `agent-version` equals the agent image tag |
| `validate-settings-changed.sh` | `debug` is `true` and `monitor-aggregation` is `maximum` |
| `validate-agents-restarted.sh` | Every agent pod was created after the lab became ready |
| `validate-cilium-ready.sh` | All agents are ready after the change |
| `validate-protected-settings.sh` | Guard: `tunnel-protocol`, `enable-policy`, `ipam` and Helm revision 1 are unchanged. It passes before any action |
