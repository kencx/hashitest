job "whoami" {
  datacenters = ["dc1"]

  group "whoami" {
    count = 1

    network {
      mode = "bridge"
      port "http" {}
    }

    task "whoami" {
      driver = "docker"

      config {
        image = "traefik/whoami"
        ports = ["http"]
        args  = ["--port", "${NOMAD_PORT_http}"]
      }

      vault {
        policies = ["whoami"]
      }

      template {
        data        = <<EOF
{{ with secret "kvv2/data/nomad/whoami" }}
AUTH="{{ .Data.data.username }}":"{{ .Data.data.password }}"
{{ end }}
EOF
        destination = "secrets/auth.env"
        env         = true
      }

      resources {
        cpu    = 5
        memory = 32
      }
    }
  }
}
