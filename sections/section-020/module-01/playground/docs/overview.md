# Install Cilium With The CLI playground

The cluster has no network plugin: its nodes are not ready and no pod can start. The namespaces `starfleet` and `outpost` exist but have no workloads.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `kubectl get nodes` and `kubectl -n kube-system get pods`.
2. Run `cilium install --list-versions`.
3. Run `cilium install --version 1.20.3 --set ipam.mode=kubernetes --dry-run-helm-values` to see the values it would use.
4. Run `cilium install --version 1.20.3 --set ipam.mode=kubernetes --wait`, then `cilium status --wait`.
5. Run `helm list -n kube-system` and `cilium uninstall`, then install again with other options.

Nothing here is graded.
