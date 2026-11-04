# Connectivity Test Flags And Monitor Output playground

Cilium 1.20.3 is installed. The namespaces `starfleet` and `outpost` hold the workloads `probe`, `shuttle` and `drifter`.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `cilium connectivity test --single-node --test pod-to-pod --timestamp` and then `echo $?`. Clean up with `cilium connectivity test --cleanup`.
2. Start `kubectl -n kube-system exec <agent pod> -c cilium-agent -- cilium-dbg monitor -t trace` and send a request from `shuttle` to `probe` with `kubectl -n starfleet exec deploy/shuttle -- curl -s http://probe:9898`.
3. Apply a NetworkPolicy that selects `probe` for ingress and has no rules. Start the monitor with `-t drop` on the node of `probe` and repeat the request.
4. Run the monitor with `--related-to <endpoint id>`. Take the ID from `cilium-dbg endpoint list`.
5. Delete the policy and check that the drops stop.

Nothing here is graded.
