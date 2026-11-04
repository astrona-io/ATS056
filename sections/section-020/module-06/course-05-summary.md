---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Summary

This module covered how to use the flags and the output of the connectivity test, and how to find the cause of a failure with the monitor.

- The flags of `cilium connectivity test` serve five purposes: select scenarios, scope the run, bound the time, produce evidence and clean up.
- A run has four phases: preparation, deployment, scenarios and summary. A failure in deployment is an environment problem. A failure in a scenario is a connectivity problem.
- The command exits with a non-zero code when a scenario or the deployment fails. Skipped scenarios do not fail a run, so read the summary.
- `cilium-dbg monitor` prints the datapath events of one node as they occur. Start it before the request you want to see.
- `-t` filters by event type, such as `drop`, `trace` or `policy-verdict`. `--from`, `--to` and `--related-to` filter by endpoint ID.
- A drop event names the reason, the two identities, the endpoint and the packet. "Policy denied" means a policy selects the destination or source and no rule allows the traffic.
- An ingress drop is reported on the node of the destination pod. An egress drop is reported on the node of the source pod.
- `hubble observe --verdict DROPPED` shows the same drops for the whole cluster when Hubble is enabled.
- A repair is proved when the request succeeds and the drop events stop.

<!-- astrona:playground:destroy -->
