# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory. The cluster has one control-plane node and one worker node, and it starts without a network plugin.
- `kubectl`, `helm` and the `cilium` command-line tool on your machine.
- You know what a ConfigMap and a DaemonSet are.

The lab starts a two-node kind cluster (Kubernetes 1.35). The task is in the question and the walkthrough is in the solution.
