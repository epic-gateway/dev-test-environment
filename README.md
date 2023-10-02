# Development/Test Environment

This project provides scripts to install and use [Vagrant](https://www.vagrantup.com/) and [Ansible](https://www.ansible.com/) to create development/test environments. There are two environments:

* [singlenode](singlenode/): a minimal environment with two Kubernetes clusters: one running EPIC, and one running the Gateway API client. Each cluster runs on a single VM.
* [multinode](multinode/): a more realistic (but much more complex) environment with two 3-node clusters, a private bridge, and a router for access to the bridge.

The singlenode environment is recommended unless you're sure that you need the multinode.
