---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Watching Events With cilium-dbg monitor

A failed action says that a request did not arrive. It does not say where it stopped. The agent knows, because the BPF programs of the datapath send an event to the agent for every notable decision, such as a drop or a policy verdict. The command `cilium-dbg monitor` prints these events live. This part shows how to run it, how to filter it and which events exist.

## What the monitor shows

The monitor runs in an agent pod and prints the events of that node only. It shows the traffic of the pods on the node and the traffic of the node itself. It does not show events of other nodes, and it does not show what happened earlier, because it prints events as they occur. To catch a problem, you start the monitor first and then repeat the failing request.

Open it in the agent of the node of the destination pod. Use the agent selection from the first module on `cilium-dbg`:

<!-- astrona:playground:renew -->

```sh
kubectl -n kube-system exec <agent pod> -c cilium-agent -- cilium-dbg monitor
```

Stop it with Ctrl-C. In a healthy idle cluster, the output is a slow stream. In a busy cluster, it is a flood, so you will almost always filter.

## Filter by event type

The flag `-t` or `--type` selects the kind of event. The common values are `drop`, `trace`, `policy-verdict`, `debug`, `capture`, `l7` and `agent`. Each is a different event group.

- `drop` shows packets that the datapath dropped, with the reason.
- `trace` shows packets that the datapath forwarded and where they went. It is the busiest type.
- `policy-verdict` shows the decision of the policy for a new connection, allow or deny.
- `agent` shows events from the agent itself, such as an endpoint created or deleted.

```sh
kubectl -n kube-system exec <agent pod> -c cilium-agent -- cilium-dbg monitor -t drop
```

The flag can be given more than once to combine types. The type `drop` is the first one to use when requests time out.

## Filter by endpoint

The flags `--from`, `--to` and `--related-to` take an endpoint ID and show only events from that endpoint, to that endpoint, or in either direction. The endpoint ID comes from `cilium-dbg endpoint list`. Because the ID is unique only on its node, use the ID from the same agent that runs the monitor.

```sh
kubectl -n kube-system exec <agent pod> -c cilium-agent -- cilium-dbg monitor --related-to <endpoint id> -t drop
```

This combination shows the drops of one pod only, and it is the filter to use on a busy node.

## Verbosity and format

The flag `-v` or `--verbose` adds more detail to each event, including the identities and the file and line of the BPF source that made the decision. The flag `-j` or `--json` prints each event as JSON for a script. Start with the default output and add `-v` when you need the identities.

## Monitor and cost

The monitor reads from a buffer of events that the agent keeps. Reading it does not slow the datapath. Some event types are produced only when enabled by a runtime option. The option `DropNotification` controls the drop events, and the option `TraceNotification` controls the trace events. The runtime options appear in the output of `cilium-dbg config`. The setting `monitor-aggregation` reduces the number of trace events by merging events of the same connection, so a connection shows its first packet and later ones only for state changes. If a trace you expect is missing, check these settings before you assume the traffic did not happen.

## What you know and what is open

You can now start the monitor on the right node, filter it by type and by endpoint and know why an event can be missing. The open question is how to read a drop event: its reason, its identities and its place in the datapath.

## Common pitfalls

> [!WARNING]
> - **Starting the monitor after the failing request.** It prints events as they occur. Start it first.
> - **Watching the wrong node.** An ingress drop is reported on the node of the destination pod.
> - **Running it unfiltered on a busy node.** Use `-t drop` and `--related-to`.
> - **Assuming a missing event means no traffic.** Aggregation and notification options reduce events.
