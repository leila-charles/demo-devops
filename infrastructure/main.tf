# 1️⃣ On définit le provider Docker
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.0"
}

# 2️⃣ On connecte Terraform à Docker local
provider "docker" {}

# 3️⃣ L'image : on build à partir du Dockerfile dans demo-devops/
resource "docker_image" "nginx_image" {
  name = "leila685/leila_pro:latest"

  build {
    context    = "${path.module}/../demo-devops"
    dockerfile = "${path.module}/../demo-devops/Dockerfile"
  }
}

# 4️⃣ Le conteneur : on configure le serveur NGINX
resource "docker_container" "nginx_container" {
  name  = "leila.charles"  # Nom visible dans Docker Desktop
  image = docker_image.nginx_image.name

  # Mappe le port 8080 local vers le port 80 du conteneur
  ports {
    internal = 80
    external = 8080
  }
}
