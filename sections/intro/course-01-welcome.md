# Welcome To The Course

This course trains you for the **Installation and Configuration** domain of the **Cilium Certified Associate (CCA)** exam. That domain is 10% of the exam. This page tells you who the course is for, what you can do at the end, which words and example app it uses, and how its pages fit together.

## Who this course is for

You know your way around Kubernetes: namespaces, Deployments, DaemonSets, ConfigMaps, `kubectl get`, `kubectl describe` and `kubectl logs`. You know what a container network plugin is for. You do not need to have installed Cilium before. Each new idea is explained the first time it appears.

The official CCA exam is a multiple-choice exam, so this course focuses on understanding. It explains how each command works, what it changes and what it leaves alone, because that is what lets you pick the right answer. The labs add practice on a real cluster. The course is independent study material and does not claim to copy the exam.

## What you can do at the end

The exam lists two competencies for this domain. Each one turns into skills you will practise.

The first competency is **using the Cilium CLI to query and modify the configuration**. You will learn to:

- Read the live Cilium configuration with `cilium config view`, and tell which keys come from Helm values and which are changed later.
- Check the version, the features and the state of an agent with `cilium version`, `cilium features status` and `cilium-dbg`.
- Explain which cluster and which permissions the CLI uses.
- Change and delete a configuration key with `cilium config set` and `cilium config delete`, control the restart of the agents, and explain who owns a setting after a Helm upgrade.

The second competency is **using the Cilium CLI to install Cilium, run connectivity tests and monitor its status**. You will learn to:

- Install Cilium with `cilium install`, choose a version and set values, and check, upgrade and uninstall it.
- Run `cilium connectivity test`, scope it to a few tests, and read its result and flow validation.
- Read `cilium status`, find a component that is not running, repair it, and collect evidence with Hubble and `cilium sysdump`.

## The words this course uses

The pages use the real terms of Kubernetes and Cilium, because those are the words you meet in the product, the error messages and the exam. Each term gets a short, plain definition the first time it appears.

A few terms come back on almost every page. The **agent** is the Cilium program that runs on every node, as the DaemonSet `cilium`. The **operator** is the Deployment `cilium-operator`, which does cluster-wide work. **Hubble** is the part that records network flows, and **Hubble Relay** collects them from all agents. The **ConfigMap `cilium-config`** holds the settings that the agents read. **Helm** is the tool that Cilium is installed with, and the Cilium CLI uses it underneath.

## The example app in your playground

The playgrounds and labs use a small example. The `probe` and `shuttle` workloads run in the `starfleet` namespace. A client called `drifter` runs in the `outpost` namespace. They are only names for examples; the explanations around them are plain technical text. Many playgrounds and labs start with a setting that is wrong or a component that is stopped on purpose. That is the material, not a fault in the course.

## How the course is laid out

The course has two sections.

| Section | What it covers |
| --- | --- |
| 010 | Query and modify the Cilium configuration |
| 020 | Install Cilium, run connectivity tests and monitor its status |

Each section has one or more **modules**, and each module teaches one skill. A module brings together four kinds of material:

| What | What it is for | Graded? |
| --- | --- | --- |
| **Reading** | A short landing page, parts that teach one idea each, and a summary | No |
| **Playground** | A small cluster on your own machine, to try everything you read | No |
| **Lab** | A cluster with a problem, a task, and a grader that checks your work | Yes |
| **Capstone** | The last lab in a section, with several tasks at once | Yes |

Each section ends with a knowledge check, and the course ends with a final knowledge check across both sections. A knowledge check is a set of questions with explanations. You pass it with 70 percent.

The best order is simple: read the parts with the playground open next to them, take each lab where the course shows it, and finish each section with its capstone.

## How to read a page

A module starts with a **landing page**. It says what the module teaches and what you should know first. At the bottom of the landing page you start the module's playground, and you keep it running while you read.

The parts of a module read like the chapters of a technical book. Each one opens with the problem it solves, explains one idea in connected paragraphs, and closes with what you now know. Run each command in your playground as you reach it.

Every part ends with a box of common pitfalls: the mistakes people make most often with what the part taught. A box looks like this:

> [!WARNING]
> **Common pitfalls.** The mistakes people make most often with what you just learned, and how to spot them. Every part ends with one.

The last page of every module is the **Summary**. It sums up what you learned and removes the playground, so your machine is clean before the next module.

All content in this course has not been run against live clusters yet. It is marked as draft. When a page describes what a command prints, it describes it in words and does not show invented output. Check the result in your own playground, and report any difference.
