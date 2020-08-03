EGW
=========

Creates an EGW on a clean Ubuntu 18.04LTS installation

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
    gitlab_user: "oz_adam"  - A version of Envoy is loaded from our private repository at gitlab, therefore a token is required
    gitlab_secret: "Qi4oXVKA1gzGdenTCd7G"
    postgresql_egw_user: egw
    postgresql_egw_password: {add a secure password here}
    database_ip: {the IP address of the EGW host, where postgresql runs}

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
