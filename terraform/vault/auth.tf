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

resource "vault_pki_secret_backend_cert" "nomad_startup" {
  depends_on            = [vault_pki_secret_backend_role.auth_role]
  backend               = vault_mount.pki_int.path
  name                  = vault_pki_secret_backend_role.auth_role.name
  common_name           = "nomad-startup@global.vault"
  ttl                   = "30d"
  auto_renew            = true
  min_seconds_remaining = 604800

  provisioner "file" {
    content     = vault_pki_secret_backend_cert.nomad_startup.certificate
    destination = "/home/vagrant/tls/nomad_startup.crt"

    connection {
      type = "ssh"
      user = "vagrant"
      host = var.vagrant_host
    }
  }

  provisioner "file" {
    content     = vault_pki_secret_backend_cert.nomad_startup.private_key
    destination = "/home/vagrant/tls/nomad_startup.pem"

    connection {
      type = "ssh"
      user = "vagrant"
      host = var.vagrant_host
    }
  }
}

resource "vault_cert_auth_backend_role" "nomad_startup" {
  backend        = vault_auth_backend.cert.path
  name           = "nomad-startup"
  display_name   = "nomad-startup"
  certificate    = vault_pki_secret_backend_cert.nomad_startup.certificate
  token_ttl      = 2592000
  token_period   = 2592000
  token_policies = ["nomad_startup", "nomad_cluster"]
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
