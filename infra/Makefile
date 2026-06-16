SHELL := /usr/bin/env bash

INFRA_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TF_DIR := $(INFRA_DIR)/terraform/environments/prod
ANSIBLE_DIR := $(INFRA_DIR)/ansible
TF := terraform -chdir=$(TF_DIR)

GPG_KEY ?= alex@afneville.com
SSH_PUBLIC_KEY := $(TF_DIR)/key.pub
ANSIBLE_INVENTORY := $(ANSIBLE_DIR)/inventory.yml

.PHONY: ssh-key tf-init tf-plan tf-apply wkd ansible-bootstrap ansible-services ansible deploy

ssh-key:
	gpg --export-ssh-key "$(GPG_KEY)" > "$(SSH_PUBLIC_KEY)"

tf-init:
	$(TF) init -backend-config=backend.hcl

tf-plan: ssh-key tf-init
	$(TF) plan

tf-apply: ssh-key tf-init
	$(TF) apply

wkd:
	"$(INFRA_DIR)/scripts/upload-wkd"

ansible-bootstrap:
	cd "$(ANSIBLE_DIR)" && \
		ansible-playbook -i "$(ANSIBLE_INVENTORY)" playbooks/site.yml \
		--tags bootstrap \
		-e "ansible_host=$$($(TF) output -raw vps_elastic_ip)"

ansible-services:
	cd "$(ANSIBLE_DIR)" && \
		ansible-playbook -i "$(ANSIBLE_INVENTORY)" playbooks/site.yml \
		--tags services \
		-e "ansible_host=$$($(TF) output -raw vps_elastic_ip)"

ansible:
	cd "$(ANSIBLE_DIR)" && \
		ansible-playbook -i "$(ANSIBLE_INVENTORY)" playbooks/site.yml \
		-e "ansible_host=$$($(TF) output -raw vps_elastic_ip)"

deploy:
	$(MAKE) tf-apply
	$(MAKE) wkd
	$(MAKE) ansible
