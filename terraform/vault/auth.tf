resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
  tune {
    default_lease_ttl = "2h"
    max_lease_ttl     = "24h"
  }
}

# admin user
resource "vault_generic_endpoint" "admin" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/admin"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true

  data_json = <<EOF
{
  "password": "${var.admin_password}",
  "token_policies": ["admin"],
  "token_ttl": "2h",
  "token_max_ttl": "24h"
}
EOF
}

resource "vault_auth_backend" "cert" {
  type = "cert"
  path = "cert"
  tune {
    default_lease_ttl = "2h"
    max_lease_ttl     = "24h"
  }
}

resource "vault_auth_backend" "agent_cert" {
  type = "cert"
  path = "agent"
  tune {
    default_lease_ttl = "2h"
    max_lease_ttl     = "24h"
  }
}

data "vault_auth_backend" "token" {
  path = "token"
}

resource "vault_token_auth_backend_role" "nomad_cluster" {
  role_name = "nomad_cluster"
  allowed_policies = [
    "whoami",
    "miniflux"
  ]
  disallowed_policies = ["nomad_cluster"]

  token_period           = 259200 # 72h
  token_explicit_max_ttl = 0
  orphan                 = true
  renewable              = true
}

# identities, entities

resource "vault_identity_entity" "admin" {
  name     = "admin"
  policies = ["default", "admin"]
}

resource "vault_identity_entity_alias" "admin_userpass" {
  name           = "admin_userpass"
  canonical_id   = vault_identity_entity.admin.id
  mount_accessor = vault_auth_backend.userpass.accessor
}

resource "vault_identity_entity_alias" "admin_token" {
  name           = "admin_token"
  canonical_id   = vault_identity_entity.admin.id
  mount_accessor = data.vault_auth_backend.token.accessor
}
