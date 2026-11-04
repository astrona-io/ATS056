---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Summary

This module covered how to find and repair a failing Cilium installation.

- Work from the outside in: `cilium status` names the component, the workload object shows desired and ready counts, the pod state classifies the failure, events and logs give the reason.
- Select Cilium pods by label: `k8s-app=cilium` for agents and `io.cilium/app=operator` for the operator. Use `--previous` for the logs of a crashed container.
- `ErrImagePull` and `ImagePullBackOff` are image or registry problems. `Init:` states are init container failures. `CrashLoopBackOff` is a crashing agent. `Running` but not ready is a failing readiness probe.
- A node stays `NotReady` until the agent writes the CNI configuration file. The agent needs a route to the API server, which `k8sServiceHost` and `k8sServicePort` give when there is no kube-proxy.
- In cluster pool IPAM mode, the operator allocates address ranges to nodes, so a stopped operator leaves new nodes without pod addresses.
- Repair in the layer of the mistake: `kubectl rollout undo` for a DaemonSet change, `helm rollback` for a Helm change, `cilium config set` for a configuration key.
- Prove a repair with `cilium status --wait` and a scoped connectivity test. Collect a sysdump before more changes when the cause is unknown.

<!-- astrona:playground:destroy -->
