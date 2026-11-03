---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Policy Enforcement And Safe Changes

The last of the four settings decides when network policy applies to a pod. The same part gives the rules for changing any of them. A wrong enforcement mode either leaves pods open when you thought they were protected or cuts off traffic that you meant to keep.

## The three modes

The key is `enable-policy` in `cilium-config`, and the Helm value is `policyEnforcementMode`. It has three values:

- `default` applies policy to an endpoint only when a policy selects it. An endpoint that no policy selects accepts all traffic. When a policy with ingress rules selects it, the endpoint denies all ingress that the rules do not allow. Egress works the same way, separately from ingress.
- `always` applies policy to every endpoint. An endpoint with no rule denies all traffic in both directions.
- `never` turns enforcement off. The agents allow all traffic, even when policies exist.

Read the current value:

<!-- astrona:playground:renew -->

```sh
cilium config view | grep -E '^enable-policy '
```

The playground starts with `never`. In that mode a `CiliumNetworkPolicy` that selects the `probe` pod has no effect.

## What an endpoint shows

Cilium calls every pod an endpoint. Each endpoint reports whether policy is enforced for it. Ask an agent:

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg endpoint list
```

The table has the columns `POLICY (ingress) ENFORCEMENT` and `POLICY (egress) ENFORCEMENT`. With `never` they show `Disabled` for every endpoint. With `default` they show `Enabled` only for endpoints that a policy selects. With `always` they show `Enabled` for all endpoints.

## Why always is dangerous

With `always`, a new pod has no rule and cannot send or receive traffic until you write the rules, including rules for DNS. Changing a running cluster to `always` therefore cuts off all workloads at once, unless the policies exist already. Test the policies first in `default` mode, and switch only after every workload has its rules.

## Which tool for which change

Two tools change a setting, and they have different effects.

`cilium config set` patches the ConfigMap and restarts the agents. It is quick, and Helm does not know about it. The next Helm upgrade can overwrite it, so use it for a test or an emergency, and write the same value into the Helm values afterwards.

A Helm upgrade changes the values and renders the ConfigMap again. Use it for any change that must stay and for any change that involves more than one value, such as the routing mode with its native routing range:

```sh
helm upgrade cilium cilium/cilium --version 1.20.3 --namespace kube-system --reuse-values --set policyEnforcementMode=default
```

The option `--reuse-values` keeps every value from the previous release. Without it Helm starts from the chart defaults and forgets your earlier values.

## A checklist before any change

Work through the same questions every time:

1. Read the current value from the ConfigMap and from an agent.
2. Find out which component reads the key and when. Most of these keys need an agent restart.
3. Check what already depends on it: pod addresses, node routes, policies, Services.
4. Choose the tool: `cilium config set` for a test, a Helm upgrade for a lasting change.
5. Make the change, wait for the rollout and run `cilium status --wait`.
6. Read the value from an agent again and test a real connection.

## What you know

You can now read the four core datapath settings, explain the three enforcement modes, and choose the right tool and the right order for a change. The next step is to practise the same flow in the playground and then in the graded task.

## Common pitfalls

> [!WARNING]
> - **Setting `always` on a cluster without policies.** All traffic stops, including DNS.
> - **Using `cilium config set` for a lasting change.** The next Helm upgrade can overwrite it.
> - **Upgrading without `--reuse-values` or a values file.** Helm then returns to the chart defaults.
> - **Checking only the ConfigMap.** The agent uses a new value only after it restarts.
