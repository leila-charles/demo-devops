terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  required_version = ">= 1.0"
}

provider "docker" {}

# Build l'image Docker à partir du Dockerfile dans demo-devops/
resource "docker_image" "nginx_image" {
  name = "leila685/leila_pro:latest"

  build {
    context    = "${Github}/../demo-devops"
    dockerfile = "${Github}/../demo-devops/Dockerfile"
  }
}

# Lancer le container NGINX localement
resource "docker_container" "nginx_container" {
  name  = "terraform-nginx"
  image = docker_image.nginx_image.name

  ports {
    internal = 80
    external = 8080
  }
}
