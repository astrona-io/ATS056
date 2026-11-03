---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. The lab has never been run, so this walkthrough shows no command output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/capstone/labs/lab-01
```

`astrona submit` right after the start shows one check that already passes: `protected-settings`. It stays your guard.

## Step 1: Query the configuration and the version

```sh
cilium config view
cilium version
kubectl -n kube-system get daemonset cilium -o jsonpath='{.spec.template.spec.containers[?(@.name=="cilium-agent")].image}'
```

Write down the values of `tunnel-protocol`, `enable-policy` and `ipam`. The version tag has the form `v1.20.3`, without the digest that follows `@`.

## Step 2: Write the report before you change anything

```sh
kubectl -n starfleet create configmap config-audit \
  --from-literal=tunnel-protocol=<value> \
  --from-literal=enable-policy=<value> \
  --from-literal=ipam=<value> \
  --from-literal=agent-version=<tag>
```

Do this first so the report holds the starting values of the three keys. The settings in step 3 do not touch these keys, so the check passes either way.

## Step 3: Change the two settings

```sh
cilium config set debug true
cilium config set monitor-aggregation maximum
```

Each command patches the ConfigMap `cilium-config` and, by default, deletes the agent and operator pods so they restart. The Helm values do not change. A later `helm upgrade` can drop these edits, so treat them as runtime changes.

## Step 4: Wait for the agents

```sh
kubectl -n kube-system rollout status daemonset/cilium
cilium status --wait
```

The check `agents-restarted` compares the creation time of each agent pod with the time the lab became ready. Pods that were not restarted fail it. A second `cilium config set` while the first restart is still running is fine, but wait for the final restart before you submit.

Submit:

```sh
astrona submit -c sections/section-010/capstone/labs/lab-01
```

## Why this works

The agent reads `cilium-config` when it starts. Editing the ConfigMap without a restart changes nothing in a running agent, and the restart in `cilium config set` is what applies the edit. The guard check proves you used the CLI and left the three protected settings and the Helm release alone.

Remove the lab when you are done:

```sh
astrona destroy ats-056-cap-010
```
