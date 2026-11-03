# Change Cilium Configuration playground

Cilium 1.20.3 is installed with Helm and default settings. The namespaces `starfleet` and `outpost` hold the workloads `probe`, `shuttle` and `drifter`.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `cilium config view | grep -E '^debug'` and note the value.
2. Run `cilium config set debug true` and watch `kubectl -n kube-system get pods -w`.
3. Run `cilium config delete debug` and watch the agents restart again.
4. Run `cilium config set debug true --restart=false`, then compare `cilium config view` with the running agent using `kubectl -n kube-system exec ds/cilium -- cilium-dbg config -a`.
5. Run `helm get values cilium -n kube-system` and notice that it did not change.

Nothing here is graded.
