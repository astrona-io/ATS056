---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Context, Permissions And Evidence

The `cilium` command does not know where your cluster is. It finds the cluster in the same way as `kubectl`, and it assumes a namespace and a Helm release name unless you say otherwise. Most failures of the tool on a working cluster come from one of these three assumptions. This part shows how the tool chooses, what Kubernetes permissions it needs, and how to collect one archive of evidence with `cilium sysdump`.

## How the tool finds the cluster

The `cilium` tool uses a kubeconfig, which is a file that lists clusters, users and contexts. A context is a named combination of one cluster, one user and one namespace. The tool picks the file and the context in this order:

1. The flag `--kubeconfig`, if you give it, names the file.
2. Otherwise the environment variable `KUBECONFIG` names one or more files.
3. Otherwise the tool reads the default file in your home directory, `~/.kube/config`.
4. The flag `--context` selects a context in that file. Without it, the tool uses the current context of the file.

This is the same logic as `kubectl`, and the same global flags exist on every `cilium` command. They also include `--as` and `--as-group`, which make the tool send its requests as another user or group. The command `cilium context` prints the configuration that the tool has chosen:

<!-- astrona:playground:renew -->

```sh
cilium context
```

Run it before a change on a machine that has more than one cluster. If the context is not the cluster you mean, a `cilium install` or a `cilium config set` would act on the wrong cluster. The check costs one command.

In the playground, the environment variable `KUBECONFIG` is already set by the platform, so the tool reaches the playground cluster without any flag. Compare it with `kubectl config current-context`; the two commands must agree.

## The namespace and the Helm release

Two more assumptions are built into the tool. The first is the namespace of the installation. The default is `kube-system`. The flag `-n` or `--namespace` changes it for one command. The environment variable `CILIUM_NAMESPACE` changes it for every command in the shell:

```sh
cilium status -n my-cilium-namespace
export CILIUM_NAMESPACE=my-cilium-namespace
```

The name `my-cilium-namespace` is a placeholder. Use it only if your installation really runs in another namespace.

The second assumption is the name of the Helm release. The default is `cilium`. If someone installed the chart with another release name, the tool does not find its Helm data, and commands that read the release fail. The global flag `--helm-release-name` sets the name:

```sh
cilium config view --helm-release-name my-release
```

Both assumptions only matter when the installation is not standard. When a `cilium` command reports that it cannot find something that you can see with `kubectl`, check the namespace and the release name first.

## The Kubernetes permissions the tool needs

The `cilium` tool has no special access. It sends requests to the Kubernetes API with the credentials of your kubeconfig, and Kubernetes role-based access control (RBAC) decides each request. The tool needs different rights for different commands:

- `cilium config view` reads the ConfigMap `cilium-config` in the Cilium namespace.
- `cilium config set` and `cilium config delete` also patch that ConfigMap, and the default restart deletes pods in the namespace.
- `cilium status` reads the DaemonSets and Deployments of Cilium and the pods that belong to them.
- `cilium features status` and `cilium sysdump` run commands inside the agent and operator pods, so they need the right to create `pods/exec`.
- `cilium install` and `cilium upgrade` create and change objects in many kinds, including cluster-wide ones, and store the Helm release in Secrets.

You can test a right without running the command. `kubectl auth can-i` asks the API server whether an identity may do something:

```sh
kubectl auth can-i patch configmaps -n kube-system
kubectl auth can-i create pods/exec -n kube-system
kubectl auth can-i get configmaps -n kube-system --as some-user
```

The first two answer for your own identity. The third uses `--as` to ask for another user; the name `some-user` is a placeholder. A read-only identity can run `cilium config view` and `cilium status`. It cannot run `cilium config set`, and the tool then shows the `Forbidden` error that the API server returned. Read that error. It names the user, the verb, the resource and the namespace that are missing.

## Collecting a sysdump

When something is wrong and somebody else must look at it, a copy of the evidence is better than a description. The command `cilium sysdump` collects the information that the Cilium project asks for in a support request, and writes it into one `.zip` file:

```sh
cilium sysdump
```

The tool collects, among other things, the pod logs of the agents, the operator and Hubble components, the description of the Kubernetes objects of Cilium, the Helm values, the ConfigMap `cilium-config`, and the output of `cilium-bugtool` from every agent. The bug tool gathers node-level facts such as the datapath state. Because the command runs commands inside the agent pods, it needs the `pods/exec` right and works only if the pods run.

The output file has the name `cilium-sysdump-<timestamp>.zip` in the current directory. The flag `--output-filename` sets another name. Two flags are worth knowing:

```sh
cilium sysdump --quick
cilium sysdump --output-filename ats-sysdump --logs-since-time 2h
```

`--quick` skips the `cilium-bugtool` output and the logs, which makes a faster but smaller archive. `--logs-since-time` limits the logs to a time range, and its default is a very long time, which is `8760h`. Use it when the cluster has been running for a long time and you only need the recent logs. The command also collects up to 10000 Hubble flows by default, set with `--hubble-flows-count`.

A sysdump can contain sensitive data: pod logs, object descriptions and the Helm values. Check it before you send it outside your organisation. The tool does not remove everything that you might consider private.

## What you know and what is open

You can now say which cluster, which namespace and which release a `cilium` command talks to, you know which Kubernetes rights its commands need, and you can collect a sysdump. You can read the configuration in every place where it lives. The open question is how to change it, and how to be sure the change takes effect and stays.

## Common pitfalls

> [!WARNING]
> - **Running a change on the wrong cluster.** The current context of the kubeconfig decides. Check `cilium context` before `install`, `upgrade` and `config set`.
> - **Assuming a standard installation.** A different namespace or Helm release name makes the tool report missing objects that exist.
> - **Using a read-only identity for `sysdump`.** It needs `pods/exec`. A role that can read pods cannot run it.
> - **Sending a sysdump unchecked.** It holds logs and the Helm values.
> - **Collecting evidence after a restart.** Restarted pods have new logs. Collect the sysdump before you try a fix.
