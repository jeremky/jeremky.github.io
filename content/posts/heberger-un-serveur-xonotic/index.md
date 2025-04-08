---
title: Héberger un serveur Xonotic
slug: heberger-un-serveur-xonotic
date: 2024-05-31T17:21:09Z
useRelativeCover: true
cover: cover.webp
tags:
  - jeux
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

Selon [Wikipedia](https://fr.wikipedia.org/wiki/Xonotic), *Xonotic est un jeu de tir à la première personne développé par Team Xonotic. C'est un jeu libre et ses données (sons, etc) sont des œuvres libres1. Il est distribué sous licence GPL2.*

Ce Fast FPS est dans la veine de Quake III arena et d'Unreal Tournament. C'est donc du shoot bien speed, avec des mécaniques de saut particulières, le tout dans des arènes labyrinthiques avec quelques zones plus ouvertes.

{{< youtube DKvh_IwG7o4 >}}

## Téléchargement du client

Le jeu est disponible sur Windows, Linux et MacOS, sur [cette page](https://xonotic.org/download/).

C'est juste un zip à décompresser, aucune installation n'est requise. Pour les utilisateurs MacOS, il est disponible dans les dépôts de brew.

## La config Docker/Podman

Comme à chaque fois, j'ajoute la configuration utilisée.

Le fichier `docker-compose.yml` :

```yml
services:
  xonotic:
    image: docker.io/itom34/xonotic:latest
    container_name: xonotic
    hostname: xonotic
    cpus: 2
    mem_limit: 1G
    volumes:
      - ./files:/root/.xonotic/
    ports:
      - 26000:26000/tcp
      - 26000:26000/udp
    healthcheck:
      test: ["CMD", "pgrep", "xonotic"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
    restart: always
```

Une fois le serveur démarré, ce dernier va créer l'arborescence des fichiers nécessaires dans le sous dossier `./files`. Vous devrez y déposer un fichier de configuration nommé `server.cfg` dans le sous dossier `data`. Vous trouverez un fichier de configuration en [exemple ici](/files/heberger-un-serveur-xonotic/server.cfg.sample). A modifier aux besoins !

Une fois le fichier déposé, on redémarre le conteneur pour prise en compte :

```bash
sudo docker restart xonotic
```

Bons frags ! :sunglasses:
