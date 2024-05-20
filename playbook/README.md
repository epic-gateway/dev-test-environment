# EPIC Devops

EPIC infrastructure project.

## Repository Structure

| Directory              | Description                                     |
| ---------------------- | -----------------------------------------       |
| [roles/epic](roles/epic) | Ansible playbook                                |
| group_vars/epic.yaml   | Default variable values (override in hosts.yml) |
| hosts.yml              | Ansible inventory                               |
| site.yml               | Top-level Ansible playbook                      |

### /etc/hosts

We use hostname-based virtual hosting for our web service proxy so you need to access it using a hostname, not an IP address.
By default, the IP address is 192.168.254.200 and the hostname is gwdev-ctl.
It can be helpful to add an entry to your `/etc/hosts` file so you can use "gwdev-ctl" with command-line tools like curl.

```
192.168.254.200    gwdev-ctl
```

## Makefile

The Makefile is mostly useful for running ad-hoc Ansible since the
command has a bunch of flags.

Run "make" to get a list of the goals.

## Environment Vars

You can override the True Ingress interface device with the
```EPIC_TRUE_INGRESS_INTF``` environment variable. This will almost
always be ```eth1``` for Vagrant-created EPIC instances.

You can configure a private image registry with the ```EPIC_PRIVATE_REGISTRY``` env var. This playbook will configure containerd to pull images from that registry using plaintext http.
