---
title: "Minecraft"
slug: minecraft
weight: 20
contextMenu: true
toc: true
tags:
  - jeux
  - docker
draft: false
lastmod: 2026-05-17
---

_[Minecraft](https://fr.wikipedia.org/wiki/Minecraft) est un jeu vidéo de type aventure « bac à sable » développé par le Suédois Markus Persson, alias Notch, puis par la société Mojang Studios. Il s'agit d'un univers composé de voxels et généré de façon procédurale, qui intègre un système d'artisanat axé sur la collecte puis la transformation de ressources naturelles (minéralogiques, fossiles, animales et végétales)._

![minecraft](minecraft.webp)

L'image que nous allons utiliser est celle de [itzg](https://docker-minecraft-server.readthedocs.io/en/latest/), qui propose tout un tas de paramètres afin de personnaliser au mieux le déploiement du serveur. Que ce soit le type de serveur (Vanilla, Spigot, Paper), la version, le mode de jeu... Plus de détails sur la page de son [projet GitHub](https://github.com/itzg/docker-minecraft-server).

## Les fichiers de déploiement

Tout d'abord, le fichier `docker-compose.yml` :

```yml {filename="docker-compose.yml"}
services:
  mcserver:
    image: docker.io/itzg/minecraft-server:latest
    container_name: mcserver
    hostname: mcserver
    env_file: mcserver.env
    cpus: 2
    mem_limit: 3G
    volumes:
      - /opt/containers/mcserver:/data
    ports:
      - 25565:25565
    tty: true
    stdin_open: true
    restart: always
```

Ensuite, le fichier de configuration `mcserver.env` :

```ini {filename="mcserver.env"}
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
