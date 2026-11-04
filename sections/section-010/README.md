---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Query And Modify The Cilium Configuration

This section covers the first competency of the Installation and Configuration domain: using the Cilium command-line tool to read and change the configuration of a running installation. You first learn where the configuration lives and how to read it, then how to change it and who owns the change afterwards.

The section has three modules. **Query The Cilium Configuration** shows that the settings are keys in one ConfigMap, how `cilium config view` reads them, how the effective state differs from the stored value, and which cluster and permissions the tool uses. **Modify The Cilium Configuration** shows what `cilium config set` and `cilium config delete` change, how the restart of the agents is controlled, and why a later Helm upgrade can keep or undo a manual change. **Core Datapath Settings Of Cilium** covers IPAM, routing, kube-proxy replacement and policy enforcement. **Inspect An Agent With cilium-dbg** shows the agent-side debug client: the status of one agent, its runtime options, its endpoints and identities, its services and its policy.

Each module has a playground and a graded lab. The section ends with a capstone lab and a knowledge check.

## Learning Outcomes

After this section you can:

- Name the object that holds the Cilium configuration and read any key in it.
- Map a Helm value to its configuration key and explain why some settings are not keys.
- Read the version, the features and the status of an agent.
- Explain which cluster context and permissions the Cilium CLI needs.
- Change and delete a key, and explain what the restart does and does not do.
- Explain who owns a setting after a change, and what a Helm upgrade can do to it.
- Run `cilium-dbg` in the agent of a chosen node, read its status and runtime options, and find the endpoint and identity of a pod.
