# packer-ansible-terraform
An example demo of using Packer, Ansible, &amp; Terraform.

## Requirements
- Packer
- Ansible
- Terraform

Setup your aws access and secret keys:
cp .env.sample .env

## Instructions

Run `make help` for a list of the available commands:

```
build                          Build and configure AMI with Packer & Ansible
deploy                         Deploy Terraform infrastructure
destroy                        Destroy Terraform infrastructure
```

## Test Suites
### Ansible - Molecule
#### Install Molecule
```
pip install molecule
molecule --version
```
#### Run tests
```
cd ansible/roles/nginx
molecule test
```