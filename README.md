# EPIC Devops

EPIC infrastructure project.

## Repository Structure

| Directory              | Description                                     |
| ---------------------- | -----------------------------------------       |
| [roles/epic](roles/epic) | Ansible playbook                                |
| group_vars/epic.yaml   | Default variable values (override in hosts.yml) |
| hosts.yml              | Ansible inventory                               |
| site.yml               | Top-level Ansible playbook                      |

## Setup

We use an Ansible vault to store secrets like authentication
credentials to our private docker repo on gitlab. You'll want to put
the vault password in a file called ```.ansible-vault-password``` so
you don't have to type it every time you run
ansible. ```.ansible-vault-password``` should be readable only by
you. Ask Toby for the password.

### /etc/hosts

We use hostname-based virtual hosting for our web service proxy so you need to access it using a hostname, not an IP address.
By default, the IP address is 192.168.254.200 and the hostname is epic-ctl.
It can be helpful to add an entry to your `/etc/hosts` file so you can use "epic-ctl" with command-line tools like curl.

```
192.168.254.200    epic-ctl
```

## Makefile

The Makefile is mostly useful for running ad-hoc Ansible since the
command has a bunch of flags.

Run "make" to get a list of the goals.

## Environment Vars

You can override the True Ingress interface device with the
```EPIC_TRUE_INGRESS_INTF``` environment variable. This will almost
always be ```eth1``` for Vagrant-created EPIC instances.
