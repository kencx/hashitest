variable "vault_address" {
  type        = string
  description = "Vault address"
  default     = "https://localhost:8200"
}

variable "vault_token" {
  type        = string
  sensitive   = true
  description = "Vault token for provider"
}

variable "vagrant_host" {
  type        = string
  description = "Vagrant Host IP"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password"
}

variable "allowed_auth_domains" {
  type        = list(string)
  description = "List of allowed_domains for PKI auth role"
  default     = ["global.vault"]
}

variable "allowed_vault_domains" {
  type        = list(string)
  description = "List of allowed_domains for PKI vault role"
  default     = ["vault.service.consul", "global.vault"]
}
