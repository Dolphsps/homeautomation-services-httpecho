project = "http-echo"

app "http-echo" {

  build {
    use "docker-pull" {
      image = "hashicorp/http-echo"
      tag   = "latest"
    }


    registry {
      use "docker" {
        image = "hashicorp/http-echo"
        tag   = "latest"
        local = true
      }
    }
  }


  deploy {
    use "nomad-jobspec" {
      // Templated to perhaps bring in the artifact from a previous
      // build/registry, entrypoint env vars, etc.
      jobspec = templatefile("${path.app}/app.nomad.tpl")

    }
  }
}
