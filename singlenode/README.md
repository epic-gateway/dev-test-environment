# Single-node Development/Test Environment

This is a good starting place if you'd like to learn about EPIC Gateway.
It's much easier to set up and manage than the [multinode](../multinode/) environment.

# Prerequisites

## Tools

Vagrant and libvirt manage the virtual machines so you'll need to ensure that both are installed and configured for your operating system.

## Network Bridge

The two VMs talk to each other using a bridge, which you need to create before bringing the VMs up.

```sh
$ ../scripts/brmgr.sh up
```

brmgr.sh uses sudo so you might be prompted for a password.

# Setup

From the singlenode directory, setup should be a single command:

```sh
$ vagrant up
```

This will create two VMs called "gateway" and "client", install a Kubernetes cluster on each of them, install the EPIC Gateway on "gateway", and install our Kubernetes Gateway API implementation on "client".
Both VMs will have kubectl configured so you can `vagrant ssh` to either one and run `kubectl` or `k`.
