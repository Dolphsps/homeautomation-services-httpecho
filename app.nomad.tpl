job "http-echo" {
  datacenters = ["dc1"]
  type        = "service"

  affinity {
    attribute = "${attr.cpu.arch}"
    value     = "amd64"
    weight    = 100
  }

  group "echo" {
    count = 2

    network {
      port "http" {
        to = 5678
      }
      mode = "host"
    }

    task "echo" {
      driver = "docker"
      config {
        image              = "hashicorp/http-echo:latest"
        image_pull_timeout = "15m"
        args = [
          "-listen", ":5678",
          "-text", "Welcome to the echo http service. You are on ${NOMAD_IP_http}",
        ]
      }

      resources {
        cpu    = 200
        memory = 128
      }

    }


    service {
      name = "http-echo"
      port = "http"
      
      connect {
        sidecar_service {}
      }
      
      tags = [
        "traefik.enable=true",
        "traefik.connect=true",
        "traefik.http.routers.http-echo-http.entrypoints=web",
        "traefik.http.routers.http-echo-http.rule=Host(`echo.mclonberg.net`)",
        #"traefik.http.middlewares.https-redirect.redirectscheme.scheme=https",
        #"traefik.http.routers.http-echo-http.middlewares=https-redirect",
        #"traefik.http.routers.http-echo-https.rule=Host(`echo.mclonberg.net`)",
        #"traefik.http.routers.http-echo-https.entrypoints=web-secure",
        #"traefik.http.routers.http-echo-https.tls=true",
        #"traefik.http.routers.http-echo-https.tls.certresolver=mclonberg-net"
      ]

    }
  }
}
