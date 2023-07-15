resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  description = "KV version 2 secrets engine"
  options = {
    version = "2"
  }
}

resource "vault_kv_secret_v2" "whoami" {
  mount = vault_mount.kvv2.path
  name  = "nomad/whoami"
  data_json = jsonencode(
    {
      username = "admin",
      password = "password"
    }
  )
}
