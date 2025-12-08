terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.0"
}

provider "docker" {}

# Build de l'image Docker à partir du Dockerfile dans demo-devops/
resource "docker_image" "nginx_image" {
  name = "leila685/leila_pro:latest"

  build {
    context    = "${path.module}/../demo-devops"
    dockerfile = "${path.module}/../demo-devops/Dockerfile"
  }
}

# Création du container NGINX
resource "docker_container" "nginx_container" {
  name  = "leila.charles"
  image = docker_image.nginx_image.name

  ports {
    internal = 80
    external = 8080
  }

  # Remplacer index.html local
  volumes {
    host_path      = abspath("${path.module}/../demo-devops/index.html")  # chemin absolu
    container_path = "/usr/share/nginx/html/index.html"
    read_only      = true
  }
}
