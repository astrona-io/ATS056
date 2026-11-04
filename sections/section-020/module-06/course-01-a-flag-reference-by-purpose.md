---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# A Flag Reference By Purpose

The command `cilium connectivity test` has many flags. They are easier to learn by purpose than in alphabetical order. This part groups them into five purposes, so that for a given need you know which flags to consider. The details of the main flags appear in the earlier module on the connectivity test; this part is the map you use when you plan a run.

## Select what runs

These flags choose the scenarios.

- `--test` takes a regular expression and runs the scenarios whose names match. A value that starts with `!` skips the matches. Repeat the flag or separate values with commas to combine them.
- `--single-node` runs only the scenarios that fit on one node. Use it on a cluster with one node or when the path between nodes is not the subject.
- `--include-unsafe-tests` adds scenarios that the tool marks as unsafe because they may disrupt the cluster. Leave it off on a cluster with traffic.

## Scope where it runs

These flags decide where the test objects live and what they talk to.

- `--test-namespace` sets the prefix of the namespace that the test creates. The tool adds a sequence number.
- `--test-concurrency` runs scenarios in several namespaces at once.
- `--external-target`, `--external-ip` and `--external-cidr` replace the default public targets of the scenarios that reach outside the cluster.
- `--force-deploy` redeploys the test workloads even if they exist.

## Bound the time

A hung scenario can block a pipeline. These flags limit the waiting.

- `--timeout` limits the whole suite.
- `--connect-timeout` and `--request-timeout` limit one connection and one request.
- `--retry` and `--retry-delay` repeat a failed request to an external target.

In a pipeline, always set `--timeout`. The other values have defaults that suit most clusters.

## Produce evidence

These flags make the run explain itself.

- `--verbose` prints more detail about each action, and `--debug` prints the internal steps of the tool. Use `--timestamp` to add the time to each line, which helps when you compare with logs.
- `--print-flows` prints the Hubble flows of each scenario, and `--all-flows` prints all of them. Use them with one scenario because the output is long.
- `--junit-file` writes a JUnit report that a build tool can show, and `--junit-property` adds a key and a value to it.
- `--pause-on-fail` stops at the first failure so you can inspect the live objects, and `--collect-sysdump-on-failure` collects a sysdump at the failure.
- `--flow-validation` takes `disabled`, `warning` or `strict`, and it decides what a mismatch between expected and observed flows does to the result.

## Clean up

The flag `--cleanup` removes the test namespace and its objects and runs no scenario. Give it the same `--test-namespace` as the run. Always clean up after an investigation, so the test pods do not stay on the cluster.

## A run assembled from the groups

A typical run for a pipeline combines one flag from several groups:

<!-- astrona:playground:renew -->

```sh
cilium connectivity test --single-node --test pod-to-pod --timeout 10m --junit-file connectivity.xml
```

It selects one scenario family, limits the scope to one node, bounds the time and produces a report. A typical run for an investigation changes the last group:

```sh
cilium connectivity test --single-node --test pod-to-pod --verbose --timestamp --print-flows --pause-on-fail
```

It keeps the same selection and adds the evidence. Choose the flags before you start, not after a failure that you cannot reproduce.

## What you know and what is open

You can now map a need to the flags that serve it. The open question is how to read what the tool prints, and what the exit code means.

## Common pitfalls

> [!WARNING]
> - **Running the full suite for one question.** Select with `--test` and scope with `--single-node`.
> - **No `--timeout` in a pipeline.** A hung scenario blocks the step.
> - **Using `--include-unsafe-tests` on a live cluster.** The extra scenarios can disrupt it.
> - **Forgetting `--cleanup`.** Test pods and a namespace stay behind.
