# Get Your Machine Ready

Every playground and lab in this course runs on your own machine, in a small Kubernetes cluster. A tool called `astrona` builds it for you, sets it up, grades your work and removes it again. This page gets your machine ready: first the tools you need, then the handful of `astrona` commands you will use every day, and last what to do when a start goes wrong.

## What you need

Install these before you start:

- **A container engine:** Docker or Podman. The cluster runs inside it.
- **`kind`:** runs Kubernetes inside the container engine. Each playground and lab is a two-node `kind` cluster with no network plugin, so Cilium can be installed into it.
- **`kubectl`:** talks to the cluster. You use it on every page.
- **`helm`:** Cilium is installed with Helm, and the Cilium CLI uses it underneath. You use it to read the release that is installed.
- **The `cilium` command-line tool:** the tool this course is about. It is version 0.20.2 in the playgrounds, which installs Cilium 1.20.3 by default.
- **The astrona command-line tool.**
- **`jq`:** reads the JSON that `cilium status -o json` and `kubectl` can print.

The playgrounds and labs also need **outbound internet** while they start. They download the container images and the Cilium chart. Without it, a start fails with network errors that have nothing to do with the topic of the module.

Cilium needs a recent Linux kernel on the nodes. A `kind` node uses the kernel of your container engine's host, which should be 5.10 or newer. On macOS and Windows, the engine runs in a virtual machine, so that machine's kernel counts. If a Cilium agent cannot start on your machine, check this first.

Several `kind` clusters at once can hit the limits of the host for file watchers. If pods fail to start with a message about too many open files, raise the inotify limits of the engine's host.

You do not have to check all of this by hand. Let `astrona` look at your machine for you:

```sh
astrona setup
```

`astrona setup` looks at what is missing, shows you each step it would take, and asks before it does anything. Later, you can check your machine at any time:

```sh
astrona check
```

## The commands you use every day

Once your machine is ready, you need only a handful of `astrona` commands. Each lab page shows the exact command to copy. Labs from the course catalog are tied to your Astrona account, so you sign in first:

```sh
astrona login
```

Next you start a playground or a lab. It looks like this:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS056.git -c sections/section-010/module-01/playground
```

When the cluster is ready, `kubectl` already points at it. You do not pick a context yourself.

To pause an environment and free your machine's memory, and to carry on later:

```sh
astrona stop <name>
astrona start <name>
```

Inside a lab, you send your work for grading with `astrona submit`. The grader checks the live cluster, so your change has to actually work. You can submit as often as you like:

```sh
astrona submit -c sections/section-010/module-01/labs/lab-01
```

When you are done with a playground or a lab, remove it:

```sh
astrona destroy <name>
```

The name is the environment's name, printed by `astrona run`. It is not the folder path. To see what is on your machine, list it:

```sh
astrona list
```

> [!WARNING]
> **Run one environment at a time.** Each playground and lab is a whole cluster, and each one installs or runs Cilium. Two running at once slow your machine down, and it is easy to send a command to the wrong one. Pause or destroy the playground before you start the lab.

## When a start goes wrong

Sometimes a playground or lab does not start cleanly. Ask `astrona` what is wrong before you try anything else:

```sh
astrona doctor
```

It checks your machine, the lab's configuration and the running lab, and tells you how to fix what it finds.

If a start fails while it downloads something, check your network first. Remember also that a playground that starts with a wrong setting or a stopped component is often like that on purpose: the landing page of the module tells you when that is the case. With your machine ready and these commands at hand, you can start the first module.
