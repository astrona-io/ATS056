# Query Cilium Configuration playground

Cilium 1.20.3 is installed with Helm. Policy enforcement is `never` and the tunnel protocol is `geneve`, so some values differ from the defaults. The namespaces `starfleet` and `outpost` hold the workloads `probe`, `shuttle` and `drifter`.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `cilium status` and read each component line.
2. Run `cilium config view` and find `tunnel-protocol`, `enable-policy`, `ipam` and `routing-mode`.
3. Compare the output with `helm get values cilium -n kube-system`.
4. Run `cilium version` and compare it with the agent image in `kubectl -n kube-system get daemonset cilium -o yaml`.
5. Run `cilium features status` and `cilium sysdump --help`.

Nothing here is graded. Break things and look again.
