# 1. On définit les outils nécessaires (Le Provider Docker)
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# 2. On connecte Terraform à ton Docker local
provider "docker" {}

# 3. L'Image : On demande à Terraform de récupérer l'image Nginx légère
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

# 4. Le Conteneur : On configure le serveur
resource "docker_container" "nginx_server" {
  image = docker_image.nginx.image_id
  name  = "mon_site_terraform" # Le nom que tu verras dans Docker Desktop

  # On mappe le port 8000 de ton PC vers le port 80 du conteneur
  ports {
    internal = 80
    external = 8000
  }

  # C'est la partie magique : on remplace le fichier index.html du conteneur
  # par TON fichier index.html local.
  volumes {
    container_path = "/usr/share/nginx/html/index.html"
    host_path      = "${path.cwd}/index.html"
    read_only      = true
  }
}