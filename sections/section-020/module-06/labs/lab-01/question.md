---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Question

Solve this question on: `terminal`

The `shuttle` Deployment in `starfleet` can no longer reach the Service `probe` on port 9898. Requests time out. Cilium 1.20.3 is installed. You must not change the installation.

1. Find the node that runs the `probe` pod and the Cilium agent pod on that node.
2. In that agent pod, start `cilium-dbg monitor` with the event type `drop`. From the `shuttle` pod, repeat the request to `probe` and read the drop event.
3. Create the ConfigMap `drop-report` in the namespace `starfleet` with these data keys: `drop-reason` (the reason text of the drop event) and `blocked-destination` (the value of the `app` label of the pod that the traffic could not reach).
4. Remove the cause of the drop, so that `shuttle` reaches `probe` again.

`kubectl` and `cilium` already point at the lab cluster.
