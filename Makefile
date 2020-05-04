.ONESHELL:
.SHELL := /usr/bin/bash

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build and configure AMI with Packer & Ansible
	cd packer
	packer build ubuntu.json

deploy: ## Deploy Terraform infrastructure
	cd terraform
	terraform init 
	terraform apply -auto-approve

destroy: ## Destroy Terraform infrastructure
	cd terraform
	terraform destroy -auto-approve