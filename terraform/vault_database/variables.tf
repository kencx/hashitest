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

variable "postgres_username" {
  type        = string
  description = "Postgres root username"
  default     = "postgres"
}

variable "postgres_password" {
  type        = string
  sensitive   = true
  description = "Postgres root password"
  default     = "postgres"
}

variable "postgres_database" {
  type        = string
  description = "Postgres database"
  default     = "postgres"
}

variable "postgres_host" {
  type        = string
  description = "Postgres host"
  default     = "localhost"
}

variable "postgres_port" {
  type        = string
  description = "Postgres port"
  default     = "5432"
}
