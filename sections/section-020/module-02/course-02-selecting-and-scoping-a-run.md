---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Selecting And Scoping A Run

A full connectivity test checks everything that the tool knows, and that is rarely what you want. After a small change you want to know whether pods still reach each other. On a cluster without internet access, some scenarios cannot pass. In a pipeline you want a report file and a time limit. The flags of `cilium connectivity test` give you these controls. This part covers the flags that choose scenarios, nodes, namespaces, targets and output.

## Selecting scenarios with --test

The flag `--test` takes a regular expression and runs only the scenarios whose names match it. A regular expression is a pattern for text: `pod-to` matches every name that contains that text. You can repeat the flag or separate values with commas, and a scenario runs when it matches one of them:

<!-- astrona:playground:renew -->

```sh
cilium connectivity test --test pod-to-pod
cilium connectivity test --test 'pod-to-pod,pod-to-service'
```

An expression that starts with `!` skips the scenarios that match. This is the way to remove the scenarios that need the internet:

```sh
cilium connectivity test --test '!pod-to-world'
```

The pattern is matched against the scenario name, not against the whole line, and it is a pattern, so `pod-to-pod` also matches a longer name that contains it. Check the names that the report prints, and write the pattern so that it matches only what you mean. You can also select a part of a scenario. The syntax `/name` after a scenario target selects the sub-scenarios by name, for example `--test '/pod-to-cidr'`. Use it only after you have seen the names in a report.

Quote the expression in the shell. The characters `!` and `|` have meaning for the shell, and a quote prevents the shell from reading them.

## Limiting a run to a single node

The flag `--single-node` limits the run to scenarios that can run on one node:

```sh
cilium connectivity test --single-node --test pod-to-pod
```

This has two effects. The tool does not deploy `echo-other-node`, because no second node is involved. It also skips every scenario that needs traffic between two nodes. Use this flag on a one-node cluster, where the other scenarios cannot work, and when you only want to check the local datapath. On a multi-node cluster, remember that the traffic between nodes is where tunnel or routing faults show up, so a run with `--single-node` does not prove that part.

The flag `--node-selector` goes in another direction. It restricts the test pods to nodes that match a label:

```sh
cilium connectivity test --node-selector kubernetes.io/hostname=<node-name>
```

Replace `<node-name>` with the name of a node. Use it to test one node or one node pool of a larger cluster. The related flag `--tolerations` adds tolerations for node taints to the test pods, so the pods can run on tainted nodes.

## Choosing the test namespace

The flag `--test-namespace` sets the prefix of the test namespace. The tool adds a sequence number, so the prefix `ats-conn` gives the namespace `ats-conn-1`:

```sh
cilium connectivity test --single-node --test pod-to-pod --test-namespace ats-conn
kubectl get namespace ats-conn-1
```

A custom prefix is useful for three reasons. It keeps the result of a run apart from another run, it fits a naming rule of your organisation, and it lets you remove the test resources by name. The flag `--namespace-labels` adds labels to the test namespace, for example to satisfy an admission policy that requires a label on every namespace.

The flag `--test-concurrency` runs the scenarios in several namespaces in parallel. A value of 2 or more creates the namespaces `<prefix>-1`, `<prefix>-2`, and so on. A value of zero or less counts as one. The parallel run is faster but needs more resources on the cluster.

## Targets, protocols and timing

Some scenarios send traffic to targets outside the cluster. The default targets are public: an address such as `1.1.1.1`, a second address and two domain names. The flags that start with `--external-` change them. For example, `--external-target` sets a domain name, `--external-ip` an IPv4 address and `--external-cidr` the address range that the test treats as external. On an isolated network, point them to a server that you control, or skip the scenarios with `!pod-to-world`.

Other flags control how the traffic behaves:

- `--ip-families` restricts the actions to `ipv4` or `ipv6`. The default is both.
- `--service-type` sets the type of the test Services. The default is `NodePort`.
- `--connect-timeout` and `--request-timeout` set the longest time for the connection and for a request. The defaults are 2 seconds and 10 seconds.
- `--retry` and `--retry-delay` repeat a failed request to an external target. The defaults are 3 retries with 3 seconds between them.
- `--timeout` sets the longest time for the whole suite. Without it, the run has no overall limit.

In a pipeline, always set `--timeout`. A hung scenario then ends the step instead of blocking it.

## Reports for pipelines

The flag `--junit-file` writes a JUnit report, an XML format that most build tools read to show test results. Each scenario becomes a test case in the file:

```sh
cilium connectivity test --single-node --test pod-to-pod --junit-file connectivity.xml --junit-property cluster=playground
```

`--junit-property` adds a key and a value to the report, which lets a dashboard tell clusters apart. The flag can be repeated. The file is the result of the run, so keep it as a build artifact.

## Re-running and redeploying

The tool deploys the test workloads at the start of a run. If you changed something about the workloads, for example the images or the labels, `--force-deploy` redeploys them even when they exist. The flag `--cleanup` does the reverse: it removes the test namespace, the deployments and the Services of the test and runs no scenario. Pass the same `--test-namespace` that you used for the run, so it removes the right namespace:

```sh
cilium connectivity test --test-namespace ats-conn --cleanup
```

Whether a finished run leaves the test workloads in place depends on the client version. Look at `kubectl get namespaces` after a run instead of assuming. The cleanup command is the sure way to remove them.

## What you know and what is open

You can now select scenarios by name and skip some, limit a run to one node, choose the namespace, change the external targets, set limits and write a JUnit report. The open question is how the test knows that a request really took the path that Cilium should handle, and what to do when a scenario fails.

## Common pitfalls

> [!WARNING]
> - **Writing an unquoted `!` or `|` in the pattern.** The shell reads it before the tool does. Quote the expression.
> - **Using a pattern that also matches other names.** The pattern is a regular expression. Read the names in the report and make the pattern exact enough.
> - **Believing that `--single-node` proves the whole cluster.** It skips every scenario that crosses nodes.
> - **Forgetting the sequence number.** `--test-namespace ats-conn` creates `ats-conn-1`. Use that name in `kubectl`.
> - **Running without `--timeout` in a pipeline.** A stuck scenario blocks the step.
