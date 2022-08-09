# Development Test Environment

This project provides scripts to install and use Vagrant to create representative Customer Environments.

# Environment Notes
The ACNDEV environment disables IPv6 currently.  May be updated in the future.


## If your running it on a host at Hurricane

 Vagrant is already setup, clone the into your home directory.  You will need to change the EXTBRIDGE in both singlenode and multinode vagrant file to reflect the configuration created by MaaS.

 EXTBRIDGE should be set to br-eno2
 LVMPOOL should be set to vagrant




## To use in your Environment

You should be able to run the single node version, the multinode version is 7 host, take a look at the resources required in the vagrantfile

Before cloning the repo a bridge connecting the router to your network is required.  A sample netplan configuration is below.  The external bridge in this case is brext0. This is the default in the vagrant scripts but can be changed in using the variable EXTBRIDGE.  

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

You will also need a copy of the frrouter box, you will need to get this from Adam, its a big file


```
$ vagrant box add router2 --name frrouter
```


## How to use.

The singlenode directory is probably rusty because I (Toby) have been using multinode/ to manage everything.

`vagrant status` will output a list of the VMs that this Vagrantfile can generate.

Execute `vagrant up router` in the multinode directory to create a router VM and a bridge ($user-epic0) to connect the VMs together.

The VM have static IP addresses on $user-epic0

1. router VM. (192.168.254.1)  This is a prebuilt router with FRR running and a FRR configuration that will accept BGP peers based upon the defaults used in EPIC.  It is connected to the host network and routes/NAT between the host network and the VM network.  The host network provides an address via DHCP.
2. EPIC VM. (192.168.254.11-13)  This is a VM that is prepared for the installation of EPIC.  Installation of EPIC is not automated.  It is connected to the bridge $user-epic0 and the default route is configured via the router VM
3. mk8s VM. (192.168.254.101-3)  This VM has the same configuration as above.  In addition mk8s is installed in this VM and some based additional tools such as aliases and kubens are added.  The mk8s is ready for the installation of PureGW

The VM are accessed from the host machine using vagrant ssh

Services that are exposed by epic are accessed via the host network on the router VM.  A static route to the network exposed (default 192.168.77.0/24) from your workstation to the vagrant router box is required to access LB services.

I (Toby) use the devops project to install k8s on client nodes since we switched from microk8s to upstream k8s. The ansible plays in this project are deprecated and probably no longer work.

