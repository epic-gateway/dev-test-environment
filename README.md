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

## Makefile

The Makefile is mostly useful for running ad-hoc Ansible since the
command has a bunch of flags.

Run "make" to get a list of the goals.

## Environment Vars

You can override the controller-manager and web-service images with
the ```EPIC_CM_IMG``` and ```EPIC_WS_IMG``` environment
variables. For example, if I wanted to use a personal dev image
instead of "latest" I could:

```
$ export EPIC_CM_IMG=registry.gitlab.com/acnodal/egw-resource-model:tobyc-dev
$ make rebuild
```

