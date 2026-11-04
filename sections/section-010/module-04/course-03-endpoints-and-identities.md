---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Endpoints And Identities

Cilium does not enforce policy on pods. It enforces policy on endpoints, and it decides who may talk to whom by identity, not by IP address. These two objects connect the Kubernetes world (pods and labels) to the datapath (numbers in BPF maps). When a flow is dropped, the endpoint and the identity are the first things to check. This part shows how to find them.

## What an endpoint is

An endpoint is the agent's record of one network interface that it manages, in practice one pod. The agent creates it when the container runtime starts the pod and the CNI plugin calls the agent. Each endpoint has a numeric endpoint ID, which is unique only on its node, an IP address, a state and an identity. The agent also keeps a few endpoints for itself and for the host.

List the endpoints on one node:

<!-- astrona:playground:renew -->

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg endpoint list
```

The table has one row per endpoint. The important columns are the endpoint ID, the policy enforcement state for ingress and egress, the identity, the labels, the IP address and the endpoint state. A healthy workload endpoint has the state `ready`. Other states, such as `waiting-for-identity` or `regenerating`, are normal for a short time while the agent computes the identity and builds the BPF program of the endpoint. An endpoint that stays in such a state needs attention.

## What an identity is

An identity is a number that stands for a set of labels. All pods with the same security-relevant labels share one identity, whatever their IP addresses are. Policy rules select by identity, so a pod that restarts with a new IP address keeps the rules that apply to it. Cilium takes the labels from the pod and its namespace, such as `app=probe` and the namespace name.

Some identities are reserved and have fixed small numbers, for example the host and the world, which means traffic from outside the cluster. Workload identities are allocated by the cluster, and the same label set gets the same number on every node. List the identities that this agent knows:

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg identity list
```

The table shows the identity number and its labels. Find the row that holds `k8s:app=probe`. Its number is the identity of the pod `probe`. An agent lists only identities that it needs, so an identity can be missing on a node where no local pod talks to it yet.

Read one identity in detail with `cilium-dbg identity get` followed by the number. Read one endpoint in detail with `cilium-dbg endpoint get` followed by the endpoint ID. The detail view includes the labels, the addresses and the policy state in a structured form.

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg endpoint get <endpoint id>
```

## The same data as Kubernetes objects

Cilium also publishes endpoints to the Kubernetes API as `CiliumEndpoint` objects, one per pod in the pod's namespace, and identities as `CiliumIdentity` objects, which are cluster scoped. You can read them with `kubectl`, which is useful when you cannot exec into the agent:

```sh
kubectl -n starfleet get ciliumendpoints
kubectl get ciliumidentities
```

The two sources agree in normal operation. The agent table is the source of truth for the node and updates first. The Kubernetes objects are a copy and can lag behind. Use the agent table for the state now and the objects for a cluster-wide view.

## Reading an enforcement column

For each endpoint, the table shows whether ingress and egress policy is enforced. With the enforcement mode set to default, an endpoint has enforcement only when a policy selects it. With the mode `always`, every endpoint is enforced. With `never`, none is. The columns therefore show the effect of the setting from the module on datapath settings on a real endpoint.

## What you know and what is open

You can find the endpoint and the identity of a pod on the agent of its node and in the Kubernetes API. The open question is how the agent handles traffic to a service, and what policy an endpoint actually has.

## Common pitfalls

> [!WARNING]
> - **Reading the endpoint table of the wrong node.** A pod appears only on the agent of its node.
> - **Treating the endpoint ID as a cluster-wide number.** It is unique per node only. The identity is the cluster-wide number.
> - **Reading an identity as a pod.** An identity stands for a label set. Many pods can share it.
> - **Panicking at `regenerating`.** It is normal for a short time. Look again before you act.
