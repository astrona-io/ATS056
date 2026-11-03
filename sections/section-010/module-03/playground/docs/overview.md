# Datapath Settings playground

Cilium 1.20.3 is installed with Helm. It uses the cluster pool IPAM mode, the Geneve tunnel and policy enforcement mode `never`. The namespaces `starfleet` and `outpost` hold the workloads `probe`, `shuttle` and `drifter`.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `cilium config view | grep -E '^(ipam|routing-mode|tunnel-protocol|enable-policy) '`.
2. Run `kubectl get ciliumnodes -o custom-columns=NAME:.metadata.name,CIDRS:.spec.ipam.podCIDRs` and compare it with `kubectl get nodes -o custom-columns=NAME:.metadata.name,CIDR:.spec.podCIDR`.
3. Run `kubectl -n kube-system exec ds/cilium -- cilium-dbg status --verbose` and find the lines for routing and kube-proxy replacement.
4. Run `kubectl -n kube-system exec ds/cilium -- cilium-dbg endpoint list` and read the policy enforcement columns.
5. Run `cilium config set enable-policy default` and run the endpoint list again after the agents restart.

Nothing here is graded.
