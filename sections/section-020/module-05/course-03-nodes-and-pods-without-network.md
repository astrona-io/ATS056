---
draft: true
exam_objectives:
- Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status
---
# Nodes And Pods Without Network

Not every installation problem shows up as a failing Cilium pod. Sometimes the nodes stay `NotReady`, or the application pods stay in `ContainerCreating` while the agent looks fine. This part explains why a node waits for the network plugin, which settings the agent needs to start, and what the operator has to do for IP address management.

## A node that stays NotReady

Right after the creation of a cluster, nodes report `NotReady`. The kubelet marks a node ready only when the container runtime reports that the network is configured, and the network is configured only when a CNI configuration file exists on the node. CNI is the Container Network Interface, the standard that lets the container runtime call a network plugin. Until Cilium is installed and its agent has written its configuration file, the nodes wait.

```sh
kubectl get nodes
kubectl describe node <node name>
```

In the conditions of `describe`, the `Ready` condition gives a message that says the network plugin is not ready or that the CNI plugin is not initialized. This message is normal before the installation. After the installation it is a sign that the agent on that node has not finished. The agent writes the file `05-cilium.conflist` into `/etc/cni/net.d/` on the node when it is ready. If the node stays `NotReady` after the agent pod runs, read the agent logs for the reason.

## The agent must reach the API server

The agent talks to the Kubernetes API server for all objects. By default it uses the in-cluster address, which goes through the `kubernetes` Service. That Service address is implemented by kube-proxy. When Cilium replaces kube-proxy, or when kube-proxy is not running yet, the Service address does not work, and the agent cannot start.

For this case the chart has the values `k8sServiceHost` and `k8sServicePort`. They give the agent the real address and port of the API server, so it does not need the Service. If you install without kube-proxy, set both values. An agent that cannot reach the API server logs that it cannot connect, and it never becomes ready:

```sh
kubectl -n kube-system logs <agent pod> -c cilium-agent --tail=50
```

Check which values are set in the running installation with `helm get values cilium -n kube-system`, and check the address against the one in your kubeconfig for the cluster.

## Pods stuck in ContainerCreating

When the agent runs and the node is ready, an application pod can still stay in `ContainerCreating`. The event of the pod names the reason. A message about the CNI plugin failing to add the pod means the call from the runtime to the agent failed. A message about no addresses available means IP address management could not give the pod an address.

With the cluster pool IPAM mode, the operator allocates a range of addresses to each node, and the agent hands out addresses from that range. If the operator does not run, a new node gets no range and its pods get no address. So the operator is part of the pod start path in that mode, not only a background job. With the Kubernetes mode, the range comes from the node object, and the operator is not needed for it.

```sh
kubectl -n starfleet describe pod <pod name>
kubectl -n kube-system get pods -l io.cilium/app=operator
```

The first command shows the events with the real error. The second shows whether the operator runs.

## A second network plugin

Cilium expects to be the only CNI plugin. If another plugin left a configuration file in `/etc/cni/net.d/` and sorts before Cilium's file, the runtime uses the other one. The chart can handle this with the `cni.exclusive` value, which makes the agent rename other CNI files. When pods get addresses from a different range than Cilium's, look for a second plugin.

## What you know and what is open

You can now explain why nodes wait, which values the agent needs to reach the API server and how the operator affects pod start. The open question is how to repair and prove the result, and what to collect if you cannot.

## Common pitfalls

> [!WARNING]
> - **Treating `NotReady` as a Kubernetes fault.** Before the network plugin is ready, `NotReady` is expected.
> - **Installing without kube-proxy and without `k8sServiceHost`.** The agent cannot reach the API server.
> - **Ignoring the operator for new nodes.** In cluster pool mode, no operator means no range for a new node.
> - **Leaving another CNI configuration on the node.** Two plugins give pods addresses from two places.
