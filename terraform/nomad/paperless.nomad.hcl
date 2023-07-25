job "paperless" {
  datacenters = ["dc1"]

  group "redis" {
    network {
      mode = "bridge"
    }

    service {
      provider = "consul"
      name     = "paperless-redis"
      port     = "6379"

      connect {
        sidecar_service {}
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:6"
      }

      resources {
        cpu    = 20
        memory = 50
      }
    }
  }

  group "app" {
    network {
      mode = "bridge"
      port "http" {
        static = 8000
        to     = 8000
      }
    }

    service {
      provider = "consul"
      name     = "paperless-app"
      port     = "http"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "paperless-redis"
              local_bind_port  = 8080
            }
          }
        }
      }
    }

    task "paperless" {
      driver = "docker"

      config {
        image              = "ghcr.io/paperless-ngx/paperless-ngx:latest"
        image_pull_timeout = "10m"
        ports              = ["http"]
      }

      env {
        USERMAP_UID         = 1000
        USERMAP_GID         = 1000
        PAPERLESS_TIME_ZONE = "Asia/Singapore"
        PAPERLESS_URL       = ""
        PAPERLESS_REDIS     = "redis://${NOMAD_UPSTREAM_ADDR_paperless_redis}"

        PAPERLESS_SECRET_KEY   = "abcd1234"
        PAPERLESS_OCR_LANGUAGE = "eng"

        PAPERLESS_OCR_PAGES         = 1
        PAPERLESS_WEBSERVER_WORKERS = 1

        # refer to docs
        PAPERLESS_TASKS_WORKERS      = 2
        PAPERLESS_THREADS_PER_WORKER = 1

        PAPERLESS_ADMIN_USER     = "admin"
        PAPERLESS_ADMIN_PASSWORD = "password"
        PAPERLESS_ADMIN_MAIL     = "admin@example.com"
      }

      resources {
        cpu    = 100
        memory = 200
      }
    }
  }
}
