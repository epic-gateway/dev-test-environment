k8s role
========
Installs k8s on a clean Ubuntu 20.04LTS installation.

Requirements
------------
Requires variables in hosts.yml to execute

Role Variables
--------------
Defaults are located in group_vars/epic.yml. You can add per-host overrides to hosts.yml.

      subnet: "192.168.102.0/24" - subnet used by PureLB to distinguish local IPs from remote ones
      pool: "192.168.102.1-192.168.102.3" - PureLB's address pool

# k8s configuration

      pod_cidr: "10.246.0.0/16"  - kubernetes POD CIDR range, needs to be configured because this block is used by endpoints and in the prototype cannot conflict with cluster

> Note: Vagrant adds 'true_ingress_remote_path' to the hosts PATH. It will overwrite original /etc/environment, ATM it contains only PATH, but could possibly cause a troube in the future.

Dependencies
------------
Requires ubuntu 20.04LTS

How to use
----------------
There's a Makefile in the project root, use the "epic-playbook" goal to run this playbook.

License
-------
BSD
