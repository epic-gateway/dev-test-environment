.DEFAULT_GOAL:=help
SHELL:=/bin/bash

TAG=registry.gitlab.com/acnodal/egw/controller:${USER}-dev

##@ Development

run: ## Run the service using "go run"
	go run ./main

image: ## Build the Docker image
	docker build --tag=${TAG} .

runimage: ## Run the service using "docker run"
	docker run --rm --publish 8080:8080 ${TAG}

push:	image ## Push the image to the repo
	docker push ${TAG}

.PHONY: help
help: ## Display this help
	@echo -e "Usage:\n  make <target>"
	@awk 'BEGIN {FS = ":.*##"}; \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  %-15s %s\n", $$1, $$2 } \
		/^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
