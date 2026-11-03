---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Question

Solve this question on: `terminal`

A new cluster for the `starfleet` and `outpost` teams has no network plugin yet. Bring up Cilium, prove that pods reach each other, and record the status.

1. Install Cilium with the Cilium command-line tool. Use version `1.20.3`, IPAM mode `kubernetes`, one replica of the operator and Hubble Relay enabled. Wait until `cilium status` reports success.
2. Run the Cilium connectivity test for the `pod-to-pod` tests only, limited to a single node, with the test namespace prefix `ats-conn`. Leave the test namespace in place.
3. Create the ConfigMap `install-report` in the namespace `starfleet` with the data keys `agents-ready`, `operator-ready` and `relay-ready`. Each holds the number of ready agents or ready replicas that the cluster reports after the test.
4. Do not install any other network plugin.

`kubectl` and `cilium` already point at the lab cluster. The nodes need internet access.
