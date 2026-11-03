# Installation and Configuration (ATS056)

Cilium Certified Associate (CCA): Installation and Configuration, worth 10% of the official curriculum. This course belongs to ATP011.

The course teaches the Cilium command-line tool: reading and changing the configuration of a running installation, installing Cilium, running connectivity tests and monitoring status. Developed reading explains mechanisms, responsible components, examples and limits. Every section has an introduction and every module closes with a summary. Each section has a knowledge check and the course has a final knowledge check. Technical content remains draft. All playgrounds and labs are UNTESTED: they were validated statically and never run.

## Course Outline

| Section / module | Module | Parts |
| --- | --- | --- |
| 010 / 01 | Query The Cilium Configuration | Where The Configuration Lives; Effective State And Features; Context, Permissions And Evidence |
| 010 / 02 | Modify The Cilium Configuration | What cilium config set Does; Deleting Keys And Controlling The Restart; Who Owns The Setting |
| 020 / 01 | Install Cilium With The CLI | Prerequisites And What Gets Installed; Install Options And Values; Verify, Upgrade And Uninstall |
| 020 / 02 | Run Cilium Connectivity Tests | What The Test Deploys And Checks; Selecting And Scoping A Run; Flow Validation And Failures |
| 020 / 03 | Monitor The Status Of Cilium | Reading cilium status; Agent Status And Workload Health; Hubble, Relay And Evidence |

## Hands-On Coverage

This course has 5 ungraded playgrounds, 5 module labs and 2 section capstones. Labs sit right after the part they practise.

| Module | Playground | Lab | Lab placement |
| --- | --- | --- | --- |
| 010/01 Query The Cilium Configuration | ats-056-pg-010-01 | Report The Effective Cilium Configuration | after part 1 |
| 010/02 Modify The Cilium Configuration | ats-056-pg-010-02 | Change A Cilium Setting With The CLI | after part 1 |
| 010 capstone | none | Query And Modify The Cilium Configuration Capstone | end of section |
| 020/01 Install Cilium With The CLI | ats-056-pg-020-01 | Install Cilium With The CLI | after part 3 |
| 020/02 Run Cilium Connectivity Tests | ats-056-pg-020-02 | Run A Scoped Connectivity Test | after part 2 |
| 020/03 Monitor The Status Of Cilium | ats-056-pg-020-03 | Find And Repair Stopped Cilium Components | after part 2 |
| 020 capstone | none | Install Cilium, Test It And Monitor It Capstone | end of section |

## Knowledge Checks

Each section has a `quiz.yaml` (`sections/section-010/quiz.yaml`, `sections/section-020/quiz.yaml`) and the course has `sections/final-domain-quiz.yaml`. The pass score is 70.

## Author Review

See [curriculum coverage](CURRICULUM.md), [primary sources](SOURCES.md), [question-bank documentation](ASSESSMENTS.md) and [contribution instructions](CONTRIBUTING.md). No runtime execution is claimed.
