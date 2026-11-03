---
estimated_duration: 25m
---

# Lab: Install Cilium With The CLI

Graded lab for the module on installing Cilium. The cluster starts with no network plugin, so its nodes are not ready. The task is to install Cilium 1.20.3 with the Cilium CLI and prove that the cluster works.

UNTESTED: this lab was written and checked statically only (`astrona validate`, `bash -n`). It has never been started, and its checks have never run against a cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-020/module-01/labs/lab-01
astrona submit -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-056-lab-020-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-helm-release.sh` | A deployed Helm release `cilium` with chart `cilium-1.20.3` |
| `validate-agent-image.sh` | The agent DaemonSet image is `cilium:v1.20.3` |
| `validate-install-settings.sh` | `ipam` is `kubernetes`, the operator has 1 replica and `hubble-relay` is available |
| `validate-agents-ready.sh` | One agent per node is ready and the operator is available |
| `validate-nodes-and-dns.sh` | Nodes are Ready and CoreDNS is available |
| `validate-single-network-plugin.sh` | Guard: no second network plugin DaemonSet. It passes before any action |
