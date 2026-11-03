# How This Course Is Made

You will trust a course more when you know how it is built. This page tells you how the content is written and checked, who is behind it, and how you can help make it better.

## How the content is written

The course targets fixed versions. The playgrounds use Kubernetes 1.35, Cilium 1.20.3 and the Cilium command-line tool 0.20.2. When a page says how a tool behaves, it means that version. Each playground installs exactly that version for you.

Facts are checked against the official Cilium and Helm documentation and against the help text of the command-line tool. Each page then explains everything you need on the page itself, so you never have to leave the course to look something up. The pages are written in plain English, with words written out in full. Each technical term gets a short, plain definition the first time it appears. The pages use the real technical terms, not metaphors, because those are the words you meet in the product, the error messages and the exam.

The labs and playgrounds have so far been checked only by reading and by static checks. A static check validates the configuration files and the scripts. It does not run them. No lab has been run against a live cluster yet, and each lab says so in its own documentation. Because of that, the course never prints command output that was not seen. It describes the result in words instead.

Finally, large parts of this course are drafted and edited with the help of AI tools. A maintainer reviews every change before it is published, and the checks above apply to all content, however it was written.

## Maintainers

A small group of people builds and looks after the course. The core maintainer is **Paris Nakita Kejser** ([@parisnakitakejser](https://github.com/parisnakitakejser)).

Every person who has changed the course is listed on the GitHub contributors page:
[github.com/astrona-io/ATS056/graphs/contributors](https://github.com/astrona-io/ATS056/graphs/contributors)

## Found a mistake? Report it

Mistakes slip through, especially while the labs have not been run live. If a command fails, a page says something wrong, or a lab grades a correct answer as wrong, please tell us. A good report takes four steps:

1. Open a new issue on GitHub: [github.com/astrona-io/ATS056/issues](https://github.com/astrona-io/ATS056/issues).
2. Say which page or lab it is (the file path is the easiest, for example `sections/section-010/module-01/labs/lab-01`).
3. Paste the command you ran and what you saw. Leave out passwords, tokens, kubeconfig files and anything else private.
4. Say what you expected to happen instead.

Want to fix it yourself? Pull requests are welcome on the same repository.

## License

The course is published under the [Apache License 2.0](https://github.com/astrona-io/ATS056/blob/main/LICENSE). You are welcome to use it, share it and build on it under the terms of that license.

The exam objectives belong to their owners. The teaching and the knowledge checks are original practice material and are not official exam questions.
