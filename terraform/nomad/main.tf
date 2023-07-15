terraform {
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "2.0.0-beta.1"
    }
  }
}

provider "nomad" {
  address = "http://localhost:4646"
}

# resource "nomad_job" "whoami" {
#   jobspec = file("${path.module}/whoami.nomad.hcl")
# }

resource "nomad_job" "countdash" {
  jobspec = file("${path.module}/countdash.nomad.hcl")
}
