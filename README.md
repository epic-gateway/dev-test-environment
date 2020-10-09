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
