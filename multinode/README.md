# Multinode Development/Test Environment

This environment is much more complicated than the [singlenode](../singlenode/) environment but it is more representative of a production environment.

# Environment Notes

A bridge connecting the router VM to your network is required.  A sample netplan configuration is below.  The external bridge in this case is brext0. This is the default in the vagrant scripts but can be changed in using the variable EXTBRIDGE.

```
network:
    ethernets:
        enp8s0f0:
            dhcp4: false
            dhcp6: false
            accept-ra: false
    bridges:
      brext0:
        interfaces:
        - enp8s0f0

    version: 2
```

You might also want to set up a route so you can reach the VMs via the router VM. This will allow you to do things like run kubectl commands on your host:

```
# ip route add 192.168.254.0/24 via 192.168.254.1
```

Clone the repo and run setup_vagrant_host.sh as root

## How to use.

`vagrant status` will output a list of the VMs that this [Vagrantfile](Vagrantfile) can generate.

Execute `vagrant up router` in this directory to create a router VM and a bridge ($user-epic0) to connect the VMs together.

The VMs have static IP addresses on $user-epic0.

1. router VM. (192.168.254.1)  This is a prebuilt router with FRR running and a FRR configuration that will accept BGP peers based upon the defaults used in EPIC.  It is connected to the host network and routes/NAT between the host network and the VM network.  The host network provides an address via DHCP.
2. EPIC VM. (192.168.254.11-13)  This is a VM that is prepared for the installation of EPIC.  Installation of EPIC is not automated.  It is connected to the bridge $user-epic0 and the default route is configured via the router VM
3. mk8s VM. (192.168.254.101-3)  This VM has the same configuration as above.  In addition mk8s is installed in this VM and some based additional tools such as aliases and kubens are added.  The mk8s is ready for the installation of PureGW
4. Ad-hoc client VM. (192.168.254.110)  This VM is used for testing the PureGW ad-hoc (i.e. non-Kubernetes) client

The VMs are accessed from the host machine using vagrant ssh.

Services that are exposed by epic are accessed via the host network on the router VM.  A static route to the network exposed (default 192.168.77.0/24) from your workstation to the vagrant router box is required to access LB services.

## Ad-hoc Client

EPIC Gateway is primarily for Kubernetes clients, but it also works with ad-hoc (i.e. non-Kubernetes) Linux clients. The Vagrantfile creates a guest called "adhoc" that can be used to experiment with this feature.

You can test it like so:

1. Go to https://github.com/epic-gateway/true-ingress and find the most recent release
1. ssh to the guest: `vagrant ssh adhoc`
1. Become root: `sudo -i`
1. Download the install script: `wget https://github.com/epic-gateway/true-ingress/releases/download/{the release from step 1}/install-true-ingress`
1. Examine `install-true-ingress` to ensure that we're not setting up a dogecoin miner on your machine
1. Run the install script: `bash install-true-ingress root`
1. Copy a valid kubectl config file to `/etc/kubnernetes/admin.conf`. The install script will also remind you to do this
1. Run a web server: `nohup python3 -m http.server --bind ::`
1. Create a Gateway/HTTPRoute: `epicctl create ad-hoc-gateway adhoc 80`
1. Create an endpoint for your web server: `epicctl create ad-hoc-endpoint 192.168.254.110 8000`
1. ssh to the epic1 node
1. `kubectl get -n epic-root gwproxies adhoc` and make a note of the "public address"
1. `curl {public_address}` using the address from the previous step
