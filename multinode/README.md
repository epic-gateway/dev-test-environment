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

The VMs are accessed from the host machine using vagrant ssh.

Services that are exposed by epic are accessed via the host network on the router VM.  A static route to the network exposed (default 192.168.77.0/24) from your workstation to the vagrant router box is required to access LB services.
