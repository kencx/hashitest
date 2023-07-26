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

resource "nomad_job" "whoami" {
  count   = 1
  jobspec = file("${path.module}/whoami.nomad.hcl")
}

resource "nomad_job" "countdash" {
  count   = 1
  jobspec = file("${path.module}/countdash.nomad.hcl")
}

resource "nomad_job" "paperless" {
  count   = 0
  jobspec = file("${path.module}/paperless.nomad.hcl")
}

resource "nomad_job" "postgres" {
  count   = 1
  jobspec = file("${path.module}/postgres.nomad.hcl")
}
