data "vault_policy_document" "update_userpass" {
  rule {
    path         = "auth/userpass/users/{{ identity.entity.aliases.${vault_auth_backend.userpass.accessor}.name }}"
    capabilities = ["update"]
    allowed_parameter {
      key   = "password"
      value = []
    }
  }
}

resource "vault_policy" "admin" {
  name   = "admin"
  policy = file("policies/admin.hcl")
}

resource "vault_policy" "update_userpass" {
  name   = "update_userpass"
  policy = data.vault_policy_document.update_userpass.hcl
}

resource "vault_policy" "kvuser" {
  name   = "kvuser"
  policy = file("policies/kvuser.hcl")
}
