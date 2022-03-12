##@ Default Goal
.PHONY: help
help: ## Display this help
	@echo "Usage:"
	@echo "  make <goal> [VAR=value ...]"
	@awk 'BEGIN {FS = ":.*##"}; \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  %-15s %s\n", $$1, $$2 } \
		/^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Ansible Goals

.PHONY: epic-playbook
epic-playbook: ## Run the EPIC playbook on a target host (specified by TARGET, e.g., "make provision TARGET=epic.acnodal.io")
	@test -n "${TARGET}" || (echo "TARGET not set. It must contain the name or address of the host to be provisioned." ; exit 1)
	ansible-playbook --verbose --ask-become-pass --vault-password-file=.ansible-vault-password --inventory=hosts.yml --limit=${TARGET} master.yml
