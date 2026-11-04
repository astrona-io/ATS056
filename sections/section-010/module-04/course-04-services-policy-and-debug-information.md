---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Services, Policy And Debug Information

An endpoint and an identity say who a pod is. Two more questions come up often: how does the agent send traffic for a Kubernetes Service, and which policy does the agent really apply to an endpoint? This part reads the service tables and the policy of one endpoint, and ends with the command that collects everything into one report.

## The service table

When kube-proxy replacement is on, Cilium implements Services itself. The agent keeps a table that maps a Service address to its backends, which are the pod addresses behind the Service. List it:

<!-- astrona:playground:renew -->

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg service list
```

Each row has a numeric ID, a frontend (the Service address and port), the type and the list of backends. A Service with a frontend but no backends is a Service whose selector matches no ready pod. Compare the table with `kubectl get endpointslices` for the same Service when a Service does not answer. If Kubernetes has backends and the agent has none, the agent has not yet received the update.

The same data exists one level lower, in the BPF map that the datapath reads for every packet. The command `cilium-dbg bpf lb list` prints that map. Use it only to prove that the datapath, not only the agent's memory, holds the entry. Day to day, `cilium-dbg service list` is enough.

## The policy of an endpoint

Writing a CiliumNetworkPolicy does not by itself prove that traffic is allowed or denied. The agent translates the rules into entries for each selected endpoint. Two commands show the result.

The command `cilium-dbg policy get` prints the rules that the agent has loaded, in JSON. It answers whether the agent knows a rule at all. The command `cilium-dbg bpf policy get` followed by an endpoint ID prints the policy map of that endpoint: the identities, ports and directions that are allowed, and the entries that deny.

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg policy get
kubectl -n kube-system exec ds/cilium -- cilium-dbg bpf policy get <endpoint id>
```

In the playground no policy exists yet, so the first command prints an empty set and the second shows the entries that every endpoint has. Apply a policy in the playground, run the commands again and compare. The endpoint ID comes from the endpoint list in the previous part.

## Node and metrics information

Two more commands answer cluster-level questions from inside the agent. The command `cilium-dbg node list` lists the nodes the agent knows and their addresses, which is useful when a node does not appear to be part of the mesh. The command `cilium-dbg metrics list` prints the Prometheus metrics of the agent as text, which is a way to read a counter without a monitoring system.

## The debug report

When a problem needs a second pair of eyes, `cilium-dbg debuginfo` collects the agent's status, configuration, endpoint list and other state into one report that you can save:

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg debuginfo > debuginfo.txt
```

It covers one agent. The cluster-wide tool is `cilium sysdump`, which runs the equivalent collection for every node and adds logs and Kubernetes objects. Review either file before you share it, because it contains addresses and configuration.

## What you know and what is open

You can now read the service table, the loaded policy and the policy map of an endpoint, and you can collect a report for one agent. You have used `cilium-dbg` as the agent's side of the CLI.

## Common pitfalls

> [!WARNING]
> - **Trusting the policy object alone.** Read the policy of the endpoint on the agent to see what is enforced.
> - **Comparing the wrong node.** Policy maps and endpoint IDs are per node.
> - **Sharing a debug report unread.** It contains cluster addresses and configuration.
> - **Using BPF commands for daily work.** They show the datapath tables and need care. Start with the service and policy commands.
