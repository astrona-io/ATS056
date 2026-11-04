# Curriculum Coverage

Exam: Cilium Certified Associate (CCA). Domain: Installation and Configuration (10%).

The [official objectives](https://training.linuxfoundation.org/certification/cilium-certified-associate-cca/) were checked on 2026-10-11. Teaching structure is independently authored and does not add official requirements.

| Section | Official objective | Modules |
| --- | --- | --- |
| 010 | Know How to Use Cilium CLI to Query and Modify the Configuration | 4 |
| 020 | Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status | 6 |

| Section / module | Module | Parts |
| --- | --- | --- |
| 010 / 01 | Query The Cilium Configuration | Where The Configuration Lives; Effective State And Features; Context, Permissions And Evidence |
| 010 / 02 | Modify The Cilium Configuration | What cilium config set Does; Deleting Keys And Controlling The Restart; Who Owns The Setting |
| 010 / 03 | Core Datapath Settings Of Cilium | IPAM Modes; Routing Mode And Tunnels; Kube-Proxy Replacement; Policy Enforcement And Safe Changes |
| 010 / 04 | Inspect An Agent With cilium-dbg | Reaching The Agent Debug Client; Agent Status And Runtime Options; Endpoints And Identities; Services, Policy And Debug Information |
| 020 / 01 | Install Cilium With The CLI | Prerequisites And What Gets Installed; Install Options And Values; Verify, Upgrade And Uninstall |
| 020 / 02 | Run Cilium Connectivity Tests | What The Test Deploys And Checks; Selecting And Scoping A Run; Flow Validation And Failures |
| 020 / 03 | Monitor The Status Of Cilium | Reading cilium status; Agent Status And Workload Health; Hubble, Relay And Evidence |
| 020 / 04 | Install And Upgrade Cilium With Helm | Repository, Chart And Release; Values And Their Precedence; Upgrade, History And Rollback; Helm And The Cilium CLI |
| 020 / 05 | Troubleshoot A Cilium Installation | Reading The Failure; Agent Pods That Do Not Start; Nodes And Pods Without Network; Fixing And Proving The Fix |
| 020 / 06 | Connectivity Test Flags And Monitor Output | A Flag Reference By Purpose; Reading The Output Of A Run; Watching Events With cilium-dbg monitor; Reading Drops And Policy Verdicts |

## Hands-On Coverage

| Module | Playground | Lab | Lab placement |
| --- | --- | --- | --- |
| 010/01 Query The Cilium Configuration | ats-056-pg-010-01 | Report The Effective Cilium Configuration | after part 1 |
| 010/02 Modify The Cilium Configuration | ats-056-pg-010-02 | Change A Cilium Setting With The CLI | after part 1 |
| 010/03 Core Datapath Settings Of Cilium | ats-056-pg-010-03 | Report And Change Datapath Settings | after part 2 |
| 010/04 Inspect An Agent With cilium-dbg | ats-056-pg-010-04 | Find The Agent, Endpoint And Identity Of A Pod | after part 3 |
| 010 capstone | none | Query And Modify The Cilium Configuration Capstone | end of section |
| 020/01 Install Cilium With The CLI | ats-056-pg-020-01 | Install Cilium With The CLI | after part 3 |
| 020/02 Run Cilium Connectivity Tests | ats-056-pg-020-02 | Run A Scoped Connectivity Test | after part 2 |
| 020/03 Monitor The Status Of Cilium | ats-056-pg-020-03 | Find And Repair Stopped Cilium Components | after part 2 |
| 020/04 Install And Upgrade Cilium With Helm | ats-056-pg-020-04 | Upgrade A Cilium Helm Release | after part 2 |
| 020/05 Troubleshoot A Cilium Installation | ats-056-pg-020-05 | Repair A Broken Cilium Agent Rollout | after part 2 |
| 020/06 Connectivity Test Flags And Monitor Output | ats-056-pg-020-06 | Find A Policy Drop With The Monitor | after part 4 |
| 020 capstone | none | Install Cilium, Test It And Monitor It Capstone | end of section |

Every lab and playground is UNTESTED: static checks only (`astrona validate`, `bash -n`, YAML parsing). Live execution is pending.
