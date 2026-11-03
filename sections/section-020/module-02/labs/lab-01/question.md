---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Question

Solve this question on: `terminal`

The platform team wants proof that pods in the cluster reach each other through Cilium before the `shuttle` and the `probe` are allowed to depend on it. Cilium is installed with Hubble Relay. Run a connectivity test, but keep it small and keep it away from the default test namespace.

1. Run the Cilium connectivity test so that it runs only the `pod-to-pod` tests.
2. Limit the run to tests that need a single node.
3. Use the test namespace prefix `ats-conn`, so that the test workloads run in the namespace `ats-conn-1`.
4. Let the run finish and leave the test namespace in place. Do not run the cleanup, and do not change the Cilium installation.

`kubectl` and `cilium` already point at the lab cluster. The cluster needs internet access to download the test images.
