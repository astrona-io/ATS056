# Helm Install And Upgrade playground

Cilium 1.20.3 is installed by Helm as the release `cilium` in `kube-system`, with `ipam.mode=kubernetes` and `operator.replicas=1`. Hubble Relay is not enabled. The namespaces `starfleet` and `outpost` hold the workloads `probe`, `shuttle` and `drifter`.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `helm list -n kube-system`, `helm history cilium -n kube-system` and `helm get values cilium -n kube-system`.
2. Run `helm repo add cilium https://helm.cilium.io/` and `helm search repo cilium/cilium --versions | head`.
3. Run `helm get values cilium -n kube-system --all | head -40` and compare it with `helm show values cilium/cilium --version 1.20.3 | head -40`.
4. Run `helm upgrade cilium cilium/cilium --version 1.20.3 -n kube-system --reuse-values --set hubble.relay.enabled=true` and watch `kubectl -n kube-system get pods -w`.
5. Run `helm history cilium -n kube-system`, then `helm rollback cilium 1 -n kube-system` and read the history again.

Nothing here is graded.
