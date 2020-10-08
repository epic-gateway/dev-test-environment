EGW
=========

Creates an EGW on a clean Ubuntu 20.04LTS installation

Requirements
------------

Requires variables in hosts.yml to execute

Role Variables
--------------

Located in hosts.yml

      bridge_name: multus0 - Used to identify the net-attach-def and create the bridge int
      isGateway: true - identifies bridge as a router - adds gateway address bridge bridge int
      subnet: "192.168.102.0/24" - subnet used by multus creating the net-attach-def
      rangeStart: "192.168.102.200" - range of addresses used by mutlus creatiing net-attach-def
      rangeEnd: "192.168.102.216"  - range of addresses used by multus creating net-attach-def
      gateway: "192.168.102.1" -  default gateway used by multus creating net-attach-def

# k8s configuration

      pod_cidr: "10.246.0.0/16"  - kubernetes POD CIDR range, needs to be configured because this block is used by endpoints and in the prototype cannot conflict with cluster

  vars:
    database_ip: {the IP address of the EGW host, where postgresql runs}
    pfc_src_path: "../packet-forwarding-component" - location of packet-forwarding-component repository (location of compiled pfc)
    pfc_remote_path: "/tmp/.acnodal/bin" - path where pfc binaries are located (location of installed)
    pfc_interface: "eth1" - interface where pfc will process packets
    pfc_gue_port_min: 5000 - port range lower bound for GUE tunnel allocation
    pfc_gue_port_max: 6000 - port range upper bound for GUE tunnel allocation
    pfc_instance_name: "egw" - pfc instance name

> Note: Vagrant adds 'pfc_remote_path' to the hosts PATH. It will overwrite original /etc/environment, ATM it contains only PATH, but could possibly cause a troube in the future.

Dependencies
------------

Requires ubuntu 20.04LTS

Requires a gitlab account and token from acnodal gitlab account to download our envoy build

Clone and build packet-forwarding-component and set its location in 'pfc_src_path'

How to use
----------------

ansible-playbook -i hosts.yml master.yml

License
-------

BSD

Author Information
------------------

Adam wrote the first version of this.......
