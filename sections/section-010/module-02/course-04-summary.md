---
draft: true
exam_objectives:
- Know How to Use Cilium CLI to Query and Modify the Configuration
---
# Summary

`cilium config set` edits the ConfigMap `cilium-config` and restarts the Cilium pods. It never edits the Helm values. Every property of the command follows from that: the change is active only after the agents restart, it is visible only in the ConfigMap, and it is not recorded in the Helm history.

## What you learned

The command sends a strategic merge patch that adds the key to the `data` field of the ConfigMap. It builds the patch by joining the key and the value as text and does not escape quotes or backslashes. By default it then deletes the agent and operator pods and returns without waiting for the new pods. The DaemonSet and the Deployment create the replacement pods, and each new agent reads the ConfigMap when it starts. The proof that a change is active is a set of agent pods that are younger than the change, a finished rollout, a `cilium status` without errors, and the setting visible in the output of `cilium-dbg config -a` in an agent.

`cilium config delete` sends a JSON patch that removes one key. It restarts the pods in the same way, and a key that does not exist is an error. An agent without a key uses the default that is built into the agent, which can differ from the value that the chart renders. The flag `--restart=false` on either command patches the ConfigMap and leaves the pods alone. You then restart them with `kubectl rollout restart` for the DaemonSet `cilium` and the Deployment `cilium-operator`. The DaemonSet in the chart for 1.20.3 allows two unavailable pods during a rollout.

Helm owns the values and renders the ConfigMap from them. During an upgrade it compares the old manifest, the new manifest and the live object. A key that the upgrade renders differently is overwritten, and a key that stays the same can keep a manual edit, so a manual edit is not safe. A change that must stay belongs in the Helm values and goes in with `cilium upgrade --set`, with the version stated. `--dry-run-helm-values` shows the values that the upgrade would store, and `helm get manifest` shows the rendered ConfigMap that Helm stored.

The key facts to remember are these:

- `config set` and `config delete` change the ConfigMap and restart the pods. Helm does not know about them.
- The command returns early. Wait for the rollout and check the pod age.
- Use `--restart=false` to batch several changes and restart once.
- Use Helm values for a change that must survive an upgrade.

<!-- astrona:playground:destroy -->
