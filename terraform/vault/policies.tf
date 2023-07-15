resource "vault_policy" "nomad_cluster" {
  name   = "nomad_cluster"
  policy = file("policies/nomad_cluster.hcl")
}

resource "vault_policy" "whoami" {
  name   = "whoami"
  policy = file("policies/whoami.hcl")
}
