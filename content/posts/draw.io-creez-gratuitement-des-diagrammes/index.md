---
title: "Draw.io : créez gratuitement des diagrammes"
slug: draw.io-creez-gratuitement-des-diagrammes
date: 2025-04-13T18:54:08.546Z
useRelativeCover: true
cover: cover.webp
tags:
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

Draw.io ([diagrams.net](https://app.diagrams.net/)) est un outil gratuit de création de diagrammes en ligne, utilisé pour concevoir facilement des schémas variés tels que des organigrammes, des diagrammes de flux, des cartes mentales, des maquettes de réseau ou encore des diagrammes UML. 

Accessible directement depuis un navigateur ou en version installable sur ordinateur, Draw.io se distingue par son interface intuitive et sa compatibilité avec des services cloud comme Google Drive, OneDrive ou GitHub. Il permet de collaborer efficacement, de sauvegarder les projets en formats standards (XML, PNG, SVG, etc.), et convient aussi bien aux professionnels qu’aux étudiants ou aux particuliers.

Dans cet article, nous allons voir comment le déployer sur un serveur personnel via Docker / Podman, et comment le coupler à l'outil [Bookstack](/posts/bookstack-solution-open-source-de-documentation).

## Installation

Même outil, même musique. Voici le fichier `compose.yml` à utiliser :

```yml
services:
  drawio:
    image: docker.io/jgraph/drawio
    container_name: drawio
    hostname: drawio
    networks:
      - nginx_proxy
    restart: always

networks:
  nginx_proxy:
    external: true
```

Pas de fichier `.env` cette fois.

### Reverse proxy

Le fichier de configuration ci-dessus est prévu pour être utilisé avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) ne propose pas de fichier sample de configuration pour Open WebUI. Vous devez donc créer un fichier nommé `/opt/nginx/nginx/proxy-confs/ollama.subdomain.conf`, et y coller le contenu suivant :

```txt
## Version 2024/07/16

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name drawio.*;

    include /config/nginx/ssl.conf;

    client_max_body_size 0;

    # enable for ldap auth (requires ldap-location.conf in the location block)
    #include /config/nginx/ldap-server.conf;

    # enable for Authelia (requires authelia-location.conf in the location block)
    #include /config/nginx/authelia-server.conf;

    # enable for Authentik (requires authentik-location.conf in the location block)
    #include /config/nginx/authentik-server.conf;

    location / {
        # enable the next two lines for http auth
        #auth_basic "Restricted";
        #auth_basic_user_file /config/nginx/.htpasswd;

        # enable for ldap auth (requires ldap-server.conf in the server block)
        #include /config/nginx/ldap-location.conf;

        # enable for Authelia (requires authelia-server.conf in the server block)
        #include /config/nginx/authelia-location.conf;

        # enable for Authentik (requires authentik-server.conf in the server block)
        #include /config/nginx/authentik-location.conf;

        include /config/nginx/proxy.conf;
        include /config/nginx/resolver.conf;
        set $upstream_app drawio;
        set $upstream_port 8080;
        set $upstream_proto http;
        proxy_pass $upstream_proto://$upstream_app:$upstream_port;

    }
}
```

> Pensez à changer la section `server_name drawio.*;` selon votre sous domaine.

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Stockage ?

Contrairement à la version officielle ([diagrams.net](https://app.diagrams.net/)), cette configuration ne permet d'utiliser que le stockage local. Je n'ai pas vérifié s'il était possible d'ajouter différentes configurations, l'objectif de ce déploiement étant surtout une utilisation couplée avec [Bookstack](/posts/bookstack-solution-open-source-de-documentation).

## Bookstack

Une fois votre application déployée, vous avez besoin de modifier la configuration de votre instance Bookstack afin d'appeler l'url de votre Draw.io tout neuf.

Pour cela, ajoutez cette variable d'environnement dans votre fichier `boostack.env` :

```txt
DRAWIO=https://drawio.mondomaine.fr/?embed=1&proto=json&spin=1&configure=1
```

Redéployez ensuite votre Bookstack (un simple arrêt / relance ne suffira pas).