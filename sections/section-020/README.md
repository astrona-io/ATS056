---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Install Cilium, Test It And Monitor It

This section covers the second competency of the Installation and Configuration domain: using the Cilium command-line tool to install Cilium, to prove that it works, and to keep watching its health. It follows the life of an installation from the first command to the first incident.

The section has six modules. **Install Cilium With The CLI** covers the prerequisites, the install options and values, and how to check, upgrade and uninstall. **Run Cilium Connectivity Tests** covers what the test deploys and checks, how to select and scope a run, and how to read flow validation and failures. **Monitor The Status Of Cilium** covers `cilium status`, the status of agents and workloads, Hubble and sysdumps. **Install And Upgrade Cilium With Helm** covers the chart, the values and upgrade and rollback. **Troubleshoot A Cilium Installation** gives an order of commands for failing components, agent pods and nodes without a network. **Connectivity Test Flags And Monitor Output** groups the flags of the connectivity test, explains how to read a run and reads drops with `cilium-dbg monitor`.

Each module has a playground and a graded lab. The section ends with a capstone lab and a knowledge check, and the course ends with a final knowledge check.

## Learning Outcomes

After this section you can:

- Check the prerequisites and install a chosen Cilium version with chosen values.
- Verify an installation and describe what upgrade and uninstall change.
- Run `cilium connectivity test`, select a few tests, and read the result.
- Explain flow validation and the options for failures and cleanup.
- Read `cilium status`, use `--wait` and know why a plain run does not fail on an unhealthy cluster.
- Find a stopped component and repair it, enable Hubble and collect a sysdump.
- Follow the order status, workload, pod, events, logs for a failing installation, and undo a bad DaemonSet change.
- Choose connectivity test flags by purpose, and read a policy drop with `cilium-dbg monitor`.
