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

# Use

The Vagrantfile creates two guest virtual machines:
```sh
$ vagrant status
Current machine states:

gateway                   running (libvirt)
gwclient                  running (libvirt)
```

```gateway``` runs the EPIC Gateway server. You can use ```vagrant ssh``` to access it. For example:

```sh
$ vagrant ssh gateway -- kubectl get nodes
NAME           STATUS   ROLES                  AGE   VERSION
epic-gateway   Ready    control-plane,master   31m   v1.23.5
```

```gwclient``` runs the Gateway client. You can use ```vagrant ssh``` to access it. For example:

```sh
$ vagrant ssh gwclient -- kubectl get gatewayclassconfig gwdev-http4 -oyaml
apiVersion: puregw.epic-gateway.org/v1
kind: GatewayClassConfig

  ... etc etc ...

status:
  conditions:
  - lastTransitionTime: "2023-10-26T17:06:23Z"
    message: EPIC connection succeeded
    observedGeneration: 1
    reason: Valid
    status: "True"
    type: Accepted
```

The status from the previous command should contain a condition with the message ```EPIC connection succeeded```. This means that the Gateway client is able to communicate with the Gateway server.

Creating a Gateway is a good next step:

```sh
$ vagrant ssh gwclient -- kubectl apply -f - < files/gateway_v1a2_gateway-devtest.yaml
deployment.apps/devtest created
service/devtest created
gateway.gateway.networking.k8s.io/devtest created
httproute.gateway.networking.k8s.io/devtest-1 created
```

Now you can check the status of the gateway:

```sh
$ vagrant ssh gwclient -- kubectl get gateways devtest
NAME      CLASS         ADDRESS        READY   AGE
devtest   gwdev-http4   192.168.77.2   True    93s
```
