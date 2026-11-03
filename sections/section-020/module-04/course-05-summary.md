---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Summary

A Cilium installation is a Helm release named `cilium` in `kube-system`. The chart creates the agent DaemonSet, the Envoy DaemonSet, the operator Deployment and the ConfigMap `cilium-config`. The operator creates the custom resource definitions later, so Helm does not own them.

Helm builds the values from the chart defaults, then values files, then `--set` options, and the later source wins. An upgrade must say what happens to the values of the earlier revision. `--reuse-values` keeps them with the old chart defaults, `--reset-values` drops them, and `--reset-then-reuse-values` keeps the user values with the new chart defaults. A saved values file removes the question.

A safe upgrade goes one minor version at a time. It starts with a healthy `cilium status`, a saved values file and the pre-flight chart. It continues with `helm upgrade`, a rollout check and a connection test. `helm history` lists every revision, and `helm rollback` creates a new revision from an earlier one. A rollback restores the manifest, but not every change to the state of the nodes.

The Cilium command-line tool uses the Helm library, so `cilium install` and `cilium upgrade` change the same release as Helm. One owner per installation avoids duplicated objects. Uninstalling removes the release but leaves the CRDs, their custom resources and possibly the CNI file on the nodes.

- Always state the chart version.
- Keep the values in a file.
- Check the rollout and the status, not only the command result.
- Use one release name and one namespace.

<!-- astrona:playground:destroy -->
