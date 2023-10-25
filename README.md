# Development/Test Environment

This project provides scripts to install and use [Vagrant](https://www.vagrantup.com/) and [Ansible](https://www.ansible.com/) to create development/test environments. There are two environments:

* singlenode: this environment; a minimal environment with two single-VM Kubernetes clusters: one running EPIC, and one running the Gateway API client.
* [multinode](multinode/): a more realistic (but much more complex) environment with two 3-node clusters, a private bridge, and a router for access to the bridge.

The singlenode environment is recommended unless you're sure that you need the multinode.

# Single-node Development/Test Environment

This is a good starting place if you'd like to learn about EPIC Gateway.
It's much easier to set up and manage than the [multinode](multinode/) environment.

# Prerequisites

## Tools

Vagrant and libvirt manage the virtual machines so you'll need to ensure that both are installed and configured for your operating system.

# Setup

From the singlenode directory, setup should be easy:

```sh
$ vagrant up gateway
$ vagrant up gwclient
```

This will create two VMs called "gateway" and "gwclient", install a Kubernetes cluster on each of them, install the EPIC Gateway on "gateway", and install our Kubernetes Gateway API implementation on "gwclient".
Both VMs will have kubectl configured so you can `vagrant ssh` to either one and run `kubectl` or `k`.
