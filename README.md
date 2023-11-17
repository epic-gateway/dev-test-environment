*NOTE*: this repo uses a git submodule so please ensure that you've initialized and updated it (see below in the [Setup section](#setup)).

# EPIC Gateway Development/Test Environment

This project provides scripts to install and configure EPIC Gateway development/test environments. There are two environments:

* This environment; a minimal environment with two single-VM Kubernetes clusters: one running EPIC, and one running a Gateway API client for testing. The two VMs use the Vagrant management network to talk to one another. This environment is a good starting place if you'd like to learn about EPIC Gateway.
* [Multinode](multinode/): a more realistic (but much more complex) environment with two 3-node clusters, a private internal bridge, a private external bridge, and a router for access to the bridge. Multinode is only recommended if you know you need it.

# Prerequisites

[Vagrant](https://www.vagrantup.com/) and [libvirt](https://libvirt.org/) manage the virtual machines so you'll need to ensure that both are installed and configured for your operating system. Vagrant uses [Ansible](https://www.ansible.com/) to configure the virtual machines that it creates.

_Hint_: on a recent Debian or Ubuntu system this command will install the tools that you need:
```sh
# apt-get update && apt-get install -y git ansible vagrant-libvirt qemu-kvm
```

# Setup

```sh
$ git clone --recurse-submodules https://github.com/epic-gateway/dev-test-environment.git
$ cd dev-test-environment
$ vagrant up          # create/configure the VMs
```

This clones the repo and submodules, creates two VMs called ```gateway``` and ```gwclient```, installs a Kubernetes cluster on each of them, installs the EPIC Gateway on ```gateway```, and installs our Kubernetes Gateway API implementation on ```gwclient```.

# Use

The ```gateway``` VM runs the EPIC Gateway cluster. You can use ```vagrant ssh``` to access it. For example:

```sh
$ vagrant ssh gateway -- kubectl get nodes
NAME           STATUS   ROLES                  AGE   VERSION
epic-gateway   Ready    control-plane,master   31m   v1.23.5
```

```gwclient``` runs the EPIC Gateway client. You can use ```vagrant ssh``` to access it. For example:

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

If your gateway is ready you can make an http request to the gateway address. EPIC will proxy the request to the client which is running an http echo server:

```sh
$ vagrant ssh gateway -- curl -s 192.168.77.2/get
{
  "args": {},
  "headers": {
    "Accept": [
      "*/*"
    ],
    "Host": [
      "192.168.77.2"
    ],

  ... etc etc ...

  "method": "GET",
  "origin": "192.168.121.83",
  "url": "http://192.168.77.2/get"
}
```
