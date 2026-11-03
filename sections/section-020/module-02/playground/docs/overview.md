# Cilium Connectivity Tests playground

Cilium 1.20.3 is installed with Hubble Relay. The namespaces `starfleet` and `outpost` hold the workloads `probe`, `shuttle` and `drifter`. The nodes need internet access to pull the test images.

The cluster has one control-plane node and one worker node (Kubernetes 1.35). `kubectl`, `helm` and `cilium` on your machine already point at it.

## Things to try

1. Run `cilium connectivity test --help` and read the flags.
2. Read the `--test`, `--single-node` and `--flow-validation` flags in the help output.
3. Run `cilium connectivity test --single-node --test pod-to-pod --test-namespace ats-conn`.
4. Look at `kubectl get namespaces` and `kubectl -n ats-conn-1 get pods`.
5. Run `cilium connectivity test --test-namespace ats-conn --cleanup` and look at the namespaces again.

Nothing here is graded.
