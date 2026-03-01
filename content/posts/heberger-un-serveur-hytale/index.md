---
title: Héberger un serveur Hytale
slug: heberger-serveur-hytale
date: 2026-02-24T21:31:06.845Z
useRelativeCover: true
cover: cover.webp
tags:
  - docker
  - linux
categories:
  - Tutos
toc: true
draft: true
---

Blabla blabla...Introduction... blabla...

2 méthodes d'installation... Images Docker jeunes... blabla...

## Installation classique

Blabla blabla... blablabla... Manuel... Blabla...

## Docker/Podman

Le fichier `compose.yml` :

```yml
services:
  hytale:
    image: docker.io/rxmarin/hytale-docker:latest
    container_name: hytale
    hostname: hytale
    env_file: hytale.env
    user: 0:0
    stdin_open: true
    tty: true
    volumes:
      - /home/bangerous/containers/hytale:/server
    ports:
      - 5520:5520/udp
    restart: always
```

Son fichier `hytale.env` associé :

```txt
TZ=Europe/Paris
SERVER_PORT=5520
AUTO_UPDATE=true
DISABLE_SENTRY=true
FORCE_UPDATE=true
```
