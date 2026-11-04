# Troubleshoot A Cilium Installation playground

Cilium 1.20.3 is installed and healthy. The namespaces `starfleet` and `outpost` hold the workloads `probe`, `shuttle` and `drifter`.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `cilium status`, then `kubectl -n kube-system get pods -l k8s-app=cilium -o wide`, then `kubectl -n kube-system describe pod` on one agent.
2. Read the agent logs with `kubectl -n kube-system logs <agent pod> -c cilium-agent --tail=50`.
3. Run `kubectl -n kube-system rollout history daemonset/cilium`.
4. Stop the operator with `kubectl -n kube-system scale deployment cilium-operator --replicas=0`, run `cilium status`, and scale it back to one.
5. Run `helm get values cilium -n kube-system` and `helm history cilium -n kube-system`.
6. Run `cilium sysdump` and look at the archive.

Nothing here is graded.
