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

# 1️⃣ Build de l'image Docker depuis le Dockerfile dans demo-devops/
resource "docker_image" "nginx_image" {
  name = "leila685/leila_pro:latest"

  build {
    context    = "${path.module}/../demo-devops"       # dossier contenant Dockerfile + site
    dockerfile = "${path.module}/../demo-devops/Dockerfile"
  }
}

# 2️⃣ Création du container NGINX
resource "docker_container" "nginx_container" {
  name  = "leila.charles"         # Nom visible dans Docker Desktop
  image = docker_image.nginx_image.name

  # Mappe le port local 8080 vers le port 80 du container
  ports {
    internal = 80
    external = 8080
  }

  # 3️⃣ Surcharge index.html du container avec ton fichier local
  volumes {
    host_path      = abspath("${path.module}/../demo-devops/index.html")
    container_path = "/usr/share/nginx/html/index.html"
    read_only      = true
  }
}
