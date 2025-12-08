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
    context    = "${path.module}/../demo-devops"       # dossier contenant Dockerfile et fichiers du site
    dockerfile = "${path.module}/../demo-devops/Dockerfile"
  }
}

# Création du container NGINX
resource "docker_container" "nginx_container" {
  name  = "leila.charles"  # Nom visible dans Docker Desktop
  image = docker_image.nginx_image.name

  # Mappe le port local 8080 vers le port 80 du container
  ports {
    internal = 80
    external = 8080
  }

  # Remplacer le fichier index.html du container par celui de ton host
  volumes {
    host_path      = "${path.module}/../demo-devops/index.html"  # chemin du fichier local
    container_path = "/usr/share/nginx/html/index.html"          # chemin dans le container
    read_only      = true
  }
}
