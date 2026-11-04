---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Agent Status And Runtime Options

The Kubernetes API tells you that an agent pod is ready. The agent tells you more: which subsystems work, which controllers fail and which options are set right now. This part reads the agent's own status and then covers `cilium-dbg config`, which shows and changes the runtime options of one agent. It also explains why that command is different from `cilium config set`.

## The status of the agent

The command `cilium-dbg status` prints one block of lines about the agent. Each line covers a subsystem: the connection to the Kubernetes API, the datapath mode, the IP address management, the proxy, the controllers and the cluster health. The verbose form adds detail, such as the list of IP ranges, the state of kube-proxy replacement and the BPF map usage:

<!-- astrona:playground:renew -->

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg status
kubectl -n kube-system exec ds/cilium -- cilium-dbg status --verbose
```

Read the output from the top. A line that names a subsystem with an error text is the place to start. The line about controllers shows how many controllers run and how many fail. A controller is a small task that the agent repeats until it succeeds, for example the synchronisation of a Kubernetes object. A failing controller is the most common first sign of a problem inside the agent.

The brief form is made for scripts. It prints one word, and the exit code is zero when the agent is healthy:

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg status --brief
```

Compare this with `cilium status` on your machine. That command reads the workload objects through the API server. `cilium-dbg status` asks the agent itself. A pod can be ready for Kubernetes while a subsystem inside the agent reports an error, and only the agent's own status shows it.

## Runtime options

The agent has two kinds of settings. Startup settings come from the ConfigMap `cilium-config` and are read when the agent starts. Runtime options are a small set that the agent lets you change while it runs. List them with:

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg config
```

Without arguments, the command prints the runtime options that you can change, with their current values. Typical names are `Debug`, `DropNotification`, `TraceNotification`, `MonitorAggregationLevel` and `PolicyAuditMode`. With `--all` it prints the whole running configuration of the agent, which is long and includes the startup settings in their effective form:

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg config --all
```

This is the agent's view of its effective configuration. It is the right place to confirm that a key from the ConfigMap reached the process, which is the question the earlier module about effective state asked from the outside.

## Changing an option on one agent

You change a runtime option by naming it with a new value:

```sh
kubectl -n kube-system exec <agent pod> -c cilium-agent -- cilium-dbg config Debug=Enable
```

The change takes effect at once and needs no restart. It is also local and temporary. It applies to this one agent, the ConfigMap does not change, and the other agents do not change. When this pod restarts, it reads the ConfigMap again and the option returns to the stored value.

That is the difference from `cilium config set`. The CLI command writes a key to the ConfigMap, so it is stored, applies to every agent and restarts the agents so that they read it. The debug command changes a running process and leaves no record in the cluster. Use `cilium-dbg config` for a short investigation on one node, for example to turn on debug logging or drop notifications while you reproduce a problem. Use `cilium config set` for a change that must stay.

Turn the option off again when you finish. A forgotten debug option on one node produces extra logs and confuses the next person who reads the output.

## What you know and what is open

You can read the agent's status, list and change its runtime options and say why such a change is temporary. The open question is how the agent maps pods to the objects it protects, which are endpoints and identities.

## Common pitfalls

> [!WARNING]
> - **Expecting a `cilium-dbg config` change to survive a restart.** It lives only in the running process.
> - **Expecting it to reach the other agents.** It changes the one agent you ran it in.
> - **Reading only `cilium status`.** A ready pod can still have a failing controller. Read the agent status too.
> - **Leaving Debug on.** Turn it off after the investigation.
