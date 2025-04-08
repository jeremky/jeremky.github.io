---
title: Héberger un serveur Minecraft
date: 2023-12-31T17:11:04Z
cover: /posts/heberger-un-serveur-minecraft/cover.webp
tags:
  - jeux
  - docker
  - podman
categories:
  - Tutos
toc: false
draft: false
---

Pas la peine de présenter ce jeu, je fais seulement ce petit article pour expliquer comment déployer rapidement et simplement un serveur Minecraft sous Docker.

Je vous suggère de passer voir les articles concernant Docker pour son installation, et l'utilisation de Docker Compose si jamais ce n'est pas déjà fait. L'image que nous allons utiliser est celle de [itzg](https://docker-minecraft-server.readthedocs.io/en/latest/), qui propose tout un tas de paramètres afin de personnaliser au mieux le déploiement du serveur. Que ce soit le type de serveur (Vanilla, Spigot, Paper), la version, le mode de jeu... Plus de détails sur la page de son [projet GitHub](https://github.com/itzg/docker-minecraft-server).

## Les fichiers de déploiement

Tout d'abord, le fichier `docker-compose.yml` :

```yml
services:
  mcserver:
    image: docker.io/itzg/minecraft-server:latest
    container_name: mcserver
    hostname: mcserver
    env_file: mcserver.env
    cpus: 2
    mem_limit: 3G
    volumes:
      - /opt/mcserver:/data
    ports:
      - 25565:25565
    tty: true
    stdin_open: true
    restart: always
```

Ensuite, le fichier de configuration `mcserver.env` :

```txt
UID=1000
GID=1000
TZ=Europe/Paris
EULA=true
OVERRIDE_SERVER_PROPERTIES=true
STOP_SERVER_ANNOUNCE_DELAY=10
MOTD=Personal Survival Server
ENABLE_ROLLING_LOGS=true
TYPE=spigot
VERSION=1.21
SNOOPER_ENABLED=false
MAX_PLAYERS=8
DIFFICULTY=hard
VIEW_DISTANCE=12
SIMULATION_DISTANCE=10
MAX_WORLD_SIZE=10000
SPAWN_PROTECTION=0
ENABLE_COMMAND_BLOCK=true
SEED=
LEVEL=world
ALLOW_NETHER=true
PVP=false
MODE=survival
FORCE_GAMEMODE=true
HARDCORE=false
OPS=JeremKy
WHITELIST=JeremKy
ENFORCE_WHITELIST=true
NETWORK_COMPRESSION_THRESHOLD=128
PLAYER_IDLE_TIMEOUT=0
MEMORY=2G
ENABLE_RCON=true
RCON_PASSWORD=Password
ONLINE_MODE=true
ENFORCE_SECURE_PROFILE=true
```

Certains paramètres dépendent du type de serveur déployé (Vanilla ou autre). En les laissant à vide, ils ne seront pas utilisés. Si vous désirez ajouter des paramètres de la documentation, ils sont à ajouter dans la zone environment du `docker-compose.yml` et dans le fichier `mcserver.env`, sinon ils ne seront pas vu par Docker.

Point important également : dans cet exemple, Docker est configuré pour limiter le nombre de CPUs utilisés, ainsi que la quantité de RAM allouée. Si vous désirez changer la quantité de RAM, la modification est à effectuer à la fois au niveau du conteneur lui-même, mais également dans la configuration de Minecraft (variables `RAM` et `MEMORY` dans le fichier `.env`)

Comme toujours, si vous avez besoin de précisions sur le déploiement et la configuration, n'hésitez pas !
