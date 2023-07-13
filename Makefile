help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## vault-init: Initialize Vault
vault-init:
	docker exec -it vault vault operator init -n=1 -key-threshold=1

## vault-unseal: Unseal Vault
vault-unseal:
	docker exec -it vault vault operator unseal $$(cat unseal_key)

## vault-apply: Apply Vault resources
vault-apply:
	cd terraform/vault && terraform apply
