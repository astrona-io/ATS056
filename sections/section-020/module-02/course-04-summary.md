---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Summary

`cilium connectivity test` acts instead of reading: it creates its own namespace and workloads, sends real requests between them, and judges the answers. A passing run shows that the datapath carries the traffic cases that the tool knows. It is not a review of the policies of your applications.

## What you learned

A run creates a namespace with the prefix `cilium-test` and a sequence number, for example `cilium-test-1`. In it, the pods `client` and `client2` send requests to the echo pods, `echo-same-node` and, on a multi-node run, `echo-other-node`. Scenarios have names such as `pod-to-pod`, `pod-to-service`, `pod-to-world` and `pod-to-host`, and each one holds several actions. The command ends with exit code zero when all scenarios pass. Some scenarios reach public targets, so a cluster without internet access fails them.

`--test` selects scenarios with regular expressions, and an expression that starts with `!` skips matches. `--single-node` limits the run to scenarios that need one node and drops `echo-other-node`. `--test-namespace` sets the prefix of the namespace, and the tool adds the sequence number. `--timeout` limits the whole suite, `--junit-file` writes a JUnit report, and the `--external-` flags change the external targets. `--cleanup` removes the test resources without running scenarios, and `--force-deploy` redeploys them. Whether a finished run leaves its workloads in place depends on the client version, so check the namespaces after a run.

The test compares the flows that Hubble records with the flows it expects. Hubble Relay offers the flows of all agents on port 4245, and the tool looks for it at `localhost:4245`. `--flow-validation` takes `disabled`, `warning` or `strict`, and the default is `warning`. A failure is read from the message, then from the state of the installation, then from a focused re-run with `--verbose` and `--print-flows`. `--pause-on-fail` and `--collect-sysdump-on-failure` keep the evidence of a failure.

The key facts to remember are these:

- Run only what you need: `--test`, `--single-node` and `--test-namespace` keep a run short.
- A pass of the requests and a pass of the flow check are different results. Use `strict` for proof.
- A scenario that fails across nodes and passes on a single node points to the node-to-node path.
- Collect evidence before you clean up.

<!-- astrona:playground:destroy -->
