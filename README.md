# egw

EGW infrastructure project

## Repository Structure

| Directory              | Description                                     |
| ---------------------- | -----------------------------------------       |
| [roles/egw](roles/egw) | Ansible playbook                                |
| group_vars/egw.yaml    | Default variable values (override in hosts.yml) |
|                        |                                                 |

## Setup

We use an Ansible vault to store secrets like authentication
credentials to our private docker repo on gitlab. You'll want to put
the vault password in a file called .ansible-vault-password so you
don't have to type it every time you run
ansible. .ansible-vault-password should be readable only by you. Ask
Toby for the password.

### /etc/hosts

We use hostname-based virtual hosting for our web service proxy so you need to access it using a hostname, not an IP address.
By default, the IP address is 192.168.66.1 and the hostname is egw-ctl.
It can be helpful to add an entry to `/etc/hosts` so you can use "egw-ctl" with command-line tools like curl.

```
192.168.66.1    egw-ctl
```

## Makefile

The Makefile is mostly useful for running ad-hoc Ansible since the
command has a bunch of flags.

Run "make" to get a list of the goals.

## Environment Vars

You can override the PFC interface device with the ```EPIC_PFC_INTF```
environment variable. This will almost always be ```eth1``` for
Vagrant-created EPIC instances.

You can override the envoy-for-egw, xds-control-plane, controller-manager and web-service images with
the ```EPIC_EP_IMG```, ```EPIC_XD_IMG```, ```EPIC_CM_IMG``` and ```EPIC_WS_IMG``` environment
variables. For example, if I wanted to use a personal dev image
instead of "latest" I could:

```
$ export EPIC_CM_IMG=registry.gitlab.com/acnodal/egw-resource-model:tobyc-dev
$ make rebuild
```

You can add extra Docker daemon configuration using the
```EXTRA_DOCKER_CONFIG``` environment variable. For example, if I
wanted to use an insecure local registry (instead of gitlab) for
development I could:

```
$ export EXTRA_DOCKER_CONFIG="insecure-registries": ["refectory.caboteria.org:5000"]
$ export EPIC_EP_IMG=refectory.caboteria.org:5000/envoy-for-egw:tobyc-dev
$ export EPIC_CM_IMG=refectory.caboteria.org:5000/egw-resource-model:tobyc-dev
$ export EPIC_WS_IMG=refectory.caboteria.org:5000/egw-web-service:tobyc-dev
$ export EPIC_XD_IMG=refectory.caboteria.org:5000/xds-operator:tobyc-dev
$ make rebuild
```
