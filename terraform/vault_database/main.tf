terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.18.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.19.0"
    }
  }
}

provider "postgresql" {
  host     = var.postgres_host
  port     = var.postgres_port
  database = var.postgres_database
  username = var.postgres_username
  password = var.postgres_password
  sslmode  = "disable"
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

locals {
  connection_url = "postgres://${var.postgres_username}:${var.postgres_password}@${var.postgres_host}:${var.postgres_port}/${var.postgres_database}"
}


resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

# NOTE: Remember to add the created policy to
# vault_token_auth_backend_role.nomad_cluster
module "miniflux" {
  source = "../modules/database"

  postgres_vault_backend  = vault_mount.db.path
  postgres_connection_url = local.connection_url

  postgres_role_name                   = "miniflux"
  postgres_role_password               = "miniflux"
  postgres_static_role_rotation_period = 86400
}

module "foo" {
  source = "../modules/database"

  postgres_vault_backend  = vault_mount.db.path
  postgres_connection_url = local.connection_url

  postgres_role_name                   = "foo"
  postgres_role_password               = "foo"
  postgres_static_role_rotation_period = 3600
}
