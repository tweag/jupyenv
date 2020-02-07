.DEFAULT_GOAL := help

################################################################################
# Test

test-build: ## Build base kernels and prints JupyterLab version.
	nix-shell --pure tests -A shell --command 'jupyter --version'

.PHONY: test-build

test-docker: ## Build Docker image with base kernels.
	nix-build tests -A docker

.PHONY: test-docker

test-examples-build: ## Build environments for examples.
	tests/run.py

.PHONY: test-examples-build

################################################################################
# Cachix

cachix: ## Upload the base kernels to Cachix.
	nix-build tests -A build | cachix push jupyterwith

.PHONY: cachix

################################################################################
# Help

help: ## Print the list of commands.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help
