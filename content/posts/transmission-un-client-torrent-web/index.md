---
title: "Transmission : un client torrent en Web"
date: 2024-11-23T01:22:38.060Z
useRelativeCover: true
cover: cover.webp
tags:
  - fichiers
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

Transmission est une application de téléchargement BitTorrent légère et open-source. Elle existe également en version Web, ce qui nous intéresse ici. Cet article sera très court, l'objectif étant surtout de partager les fichiers nécessaires à son installation.

## Installation

Voici les fichiers de configuration Docker nécessaires pour l'installation de Transmission :

Le fichier `docker-compose.yml` :

```yml
services:
  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    hostname: transmission
    env_file: transmission.env
    networks:
      - nginx_proxy
    volumes:
      - /opt/transmission/data:/config
      - /opt/transmission/downloads:/downloads
      - /opt/transmission/folder:/watch
    ports:
      - 51413:51413
      - 51413:51413/udp
    restart: always

networks:
  nginx_proxy:
    external: true
```

Et son fichier `transmission.env` :

```txt
PUID=1000
PGID=1000
TZ=Europe/Paris
USER=
PASS=
```

> Si aucun user/password n'est défini, l'interface sera directement accessible sans authentification. Je vous suggère de vous référer à l'article au sujet d'[Authelia](/posts/authelia-serveur-dauthentification-open-source/) pour centraliser vos authentifications.

Pensez à adapter les chemins des volumes dans le fichier `docker-compose.yml` vers les dossiers où vous voulez stocker vos fichiers.

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisé avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) propose un fichier sample de configuration, il vous suffit juste de modifier votre nom de domaine en conséquence :

```bash
sudo cp /opt/nginx/nginx/proxy-confs/transmission.subdomain.conf.sample /opt/nginx/nginx/proxy-confs/transmission.subdomain.conf
sudo sed -i "s,server_name transmission,server_name <votre_sous_domaine>,g" /opt/nginx/nginx/proxy-confs/transmission.subdomain.conf
```

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Utilisation

Une fois l'application déployée, rien de bien compliqué. Vous pouvez cliquer sur le + en haut à gauche pour ajouter un fichier torrent, ou lui donner directement un lien :

{{< image src="addtorrent.webp" style="border-radius: 8px;" >}}

Une fois votre torrent ajouté, voici le rendu de l'interface :

{{< image src="download.webp" style="border-radius: 8px;" >}}

Bons transferts !
