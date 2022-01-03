project = "http-echo"

app "http-echo" {

  build {
    use "docker-pull" {
      image = "hashicorp/http-echo"
      tag   = "latest"
    }
  }


  deploy { /*
    use "nomad-jobspec" {
      // Templated to perhaps bring in the artifact from a previous
      // build/registry, entrypoint env vars, etc.
      jobspec = templatefile("${path.app}/app.nomad.tpl")
    }
  */

    use "docker" {
      command = ["-listen", ":3000", "-text", "hello"]
    }
  }
}
