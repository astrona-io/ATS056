---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Summary

Four settings shape the datapath of a Cilium installation, and each one has a Helm value, a `cilium-config` key and a state that the agent reports.

The IPAM mode decides who gives each node its range of pod addresses. In cluster pool mode the operator splits a cluster-wide range and writes the node ranges into the `CiliumNode` resources. In `kubernetes` mode Cilium uses the `node.spec.podCIDR` that Kubernetes assigned. Changing the mode on a running cluster is a planned maintenance task, not a routine step.

The routing mode decides how packets cross the node network. Tunnel mode wraps each packet in VXLAN or Geneve and needs only UDP connectivity between the nodes, but the header lowers the usable MTU. Native routing sends the original packets and needs a node network that knows the pod ranges, together with `ipv4NativeRoutingCIDR` and, on a shared layer 2 network, `autoDirectNodeRoutes`.

Kube-proxy replacement moves the Service-to-backend lookup into eBPF maps of the agent. A cluster without `kube-proxy` needs `k8sServiceHost` and `k8sServicePort` so that the agent can reach the API server at start. The agent status shows whether the replacement is really active.

The policy enforcement mode `default` applies policy only to endpoints that a policy selects, `always` applies it to all endpoints, and `never` turns it off. The endpoint list shows the result for each pod.

- `cilium config set` is for tests and emergencies. A Helm upgrade with the values that belong together is for lasting changes.
- A new value is active only after the agents restart.
- Read the value from the ConfigMap and from an agent before and after a change.

<!-- astrona:playground:destroy -->
