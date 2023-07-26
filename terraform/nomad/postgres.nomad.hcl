job "miniflux" {
  datacenters = ["dc1"]

  group "miniflux" {

    network {
      mode = "bridge"
      port "db" {
        static = "5432"
        to     = "5432"
      }
      port "http" {
        static = "8120"
        to     = "8120"
      }
    }

    task "postgres" {
      driver = "docker"
      lifecycle {
        hook    = "prestart"
        sidecar = true
      }

      config {
        image = "postgres:latest"
        ports = ["db"]

        volumes = [
          "/home/vagrant/postgres:/var/lib/postgresql/data",
        ]
      }

      env {
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "postgres"
      }

      resources {
        cpu    = 150
        memory = 150
      }
    }

    task "miniflux" {
      driver = "docker"

      config {
        image = "miniflux/miniflux:latest"
        ports = ["http"]
      }

      vault {
        policies = ["miniflux"]
      }

      env {
        PORT              = NOMAD_PORT_http
        DEBUG             = 1
        RUN_MIGRATIONS    = 1
        POLLING_FREQUENCY = 1440
        CREATE_ADMIN      = 1
        ADMIN_USERNAME    = "admin"
        ADMIN_PASSWORD    = "password"
      }

      template {
        data        = <<EOF
{{ with secret "postgres/static-creds/miniflux" }}
DATABASE_URL = "postgres://miniflux:{{ .Data.password }}@localhost:{{ env "NOMAD_PORT_db" }}/miniflux?sslmode=disable"
{{ end }}
EOF
        destination = "secrets/.env"
        env         = true
      }

      resources {
        cpu    = 35
        memory = 150
      }
    }
  }
}
