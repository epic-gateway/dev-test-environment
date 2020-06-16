EGW
=========

Creates an EGW on a clean Ubuntu 18.04LTS installation

Requirements
------------

Requires variables in hosts.yml to execute

Role Variables
--------------

Located in hosts.yml

master_int: enp1s0   - interface used on host by multus in the default net-attach-def called linux-ipvlan and configuring the ipvlan virtual interface -current version supports single interface
      subnet: "192.168.101.0/24" - subnet used by Multus when creating the defaul net-attach-def called linux-ipvlan
      rangeStart: "192.168.101.200" - range of addresses used by Multus when creating the defaul net-attach-def called linux-ipvlan
      rangeEnd: "192.168.151.216" - range of addressed used by Multus when creating the default net-attach-def called linux-ipvlan
      gateway: "192.168.101.1" - default gateway used by Multus when creating the default net-attach-def called linux-ipvlan and configuring the ipvlan virtual interface



# k8s configuration

      pod_cidr: "10.245.0.0/16"  - kubernetes POD CIDR range, needs to be configured because this block is used by endpoints and in the prototype cannot conflict with cluster
  
  vars:
    gitlab_user: "oz_adam"  - A version of Envoy is loaded from our private repository at gitlab, therefore a token is required
    gitlab_secret: "Qi4oXVKA1gzGdenTCd7G"

Dependencies
------------

Requires ubuntu 18.04LTS

Requires a gitlab account and token from acnodal gitlab account to download our envoy build

How to use
----------------

ansible-playbook -i hosts.yml master.yml

License
-------

BSD

Author Information
------------------

Adam wrote the first version of this.......
