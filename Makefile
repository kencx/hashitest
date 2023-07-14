help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## vault-apply: Apply Vault resources
vault-apply:
	cd terraform/vault && terraform apply
