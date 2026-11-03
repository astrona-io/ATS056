---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Question

Solve this question on: `terminal`

The platform team wants flow data for the `shuttle` in `starfleet` and the `drifter` in `outpost`. Cilium 1.20.3 is installed by Helm as the release `cilium` in the namespace `kube-system`, with `ipam.mode=kubernetes` and `operator.replicas=1`. Hubble Relay does not run yet.

1. Upgrade the existing Helm release `cilium` so that Hubble Relay runs. Use the chart version 1.20.3.
2. Keep every value of the first installation. The release must still have `ipam.mode=kubernetes` and `operator.replicas=1` after the upgrade.
3. Wait until Hubble Relay has one ready replica and all agents are ready.
4. Record the new Helm revision number and the chart name with its version in a ConfigMap named `upgrade-report` in the namespace `starfleet`. Use the keys `revision` and `chart`. The chart value has the form shown in the `CHART` column of `helm list`.
5. Do not install a second release and do not run `cilium install`.

`kubectl`, `helm` and `cilium` already point at the lab cluster.
