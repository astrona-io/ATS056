# Inspect An Agent With cilium-dbg playground

Cilium 1.20.3 is installed. The namespaces `starfleet` and `outpost` hold the workloads `probe`, `shuttle` and `drifter`.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `kubectl -n kube-system get pods -l k8s-app=cilium -o wide` and `kubectl -n starfleet get pods -o wide`.
2. Run `kubectl -n kube-system exec ds/cilium -- cilium-dbg status --brief` and then `--verbose`.
3. Run `cilium-dbg endpoint list` and `cilium-dbg identity list` in the agent of each node and compare.
4. Run `cilium-dbg config`, then `cilium-dbg config Debug=Enable` in one agent, and run `cilium config view` to see that the ConfigMap did not change.
5. Run `cilium-dbg service list` and `cilium-dbg policy get`.

Nothing here is graded.
