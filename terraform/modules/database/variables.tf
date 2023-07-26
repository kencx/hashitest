variable "postgres_connection_url" {
  type        = string
  description = "Postgres connection URL"
  default     = "postgres://postgres:postgres@localhost:5432/postgres"
}

variable "postgres_vault_backend" {
  type        = string
  description = "Database secrets engine backend for Postgres"
  default     = "postgres"
}

variable "postgres_role_name" {
  type        = string
  description = "Postgres role name"
}

variable "postgres_role_password" {
  type        = string
  sensitive   = true
  description = "Temporary password for Postgres role. This will be rotated and managed by Vault."
}

variable "postgres_static_role_rotation_period" {
  type        = number
  description = "Postgres role password rotation period (in s)."
  default     = 86400
}
