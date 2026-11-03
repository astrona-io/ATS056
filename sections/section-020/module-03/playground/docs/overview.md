# Monitor Cilium Status playground

Cilium 1.20.3 is installed with Hubble Relay. The namespaces `starfleet` and `outpost` hold the workloads `probe`, `shuttle` and `drifter`.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `cilium status`, then `cilium status --verbose`, then `cilium status -o json`.
2. Run `kubectl -n kube-system exec ds/cilium -- cilium-dbg status --verbose`.
3. Scale `cilium-operator` to zero with `kubectl -n kube-system scale deployment cilium-operator --replicas=0` and run `cilium status` again.
4. Scale it back to one and run `cilium status --wait`.
5. Run `cilium hubble port-forward &` and `hubble status` if the `hubble` command is installed.

Nothing here is graded.
