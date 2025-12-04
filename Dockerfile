# On prend une image légère de Nginx
FROM nginx:alpine

# On supprime la page par défaut de Nginx
RUN rm -rf /usr/share/nginx/html/*

# On copie notre index.html dans le dossier servi par Nginx
COPY index.html /usr/share/nginx/html/index.html

# On expose le port 80 du conteneur
EXPOSE 80

# Commande de démarrage (déjà définie dans l'image nginx, mais on la laisse pour être explicite)
CMD ["nginx", "-g", "daemon off;"]
