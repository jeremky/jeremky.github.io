---
title: Serveur Minecraft Infinity Dungeon
date: 2024-08-05T20:56:18+02:00
cover: /img/posts/serveur-minecraft-infinity-dungeon/cover.webp
tags:
  - jeux
  - docker
  - podman
categories:
  - Tutos
toc: false
draft: false
---

Euh... Minecraft ? Pas tout à fait. [Minecraft Infinity Dungeon](https://www.planetminecraft.com/project/infinity-dungeons/) est une map aventure de type [Roguelike](https://fr.wikipedia.org/wiki/Roguelike). 

Tous les codes de ce genre de jeu s'y trouvent : des zones générées de façon procédurale, des récompenses, des salles de boss...

{{< image src="/img/posts/serveur-minecraft-infinity-dungeon/boss.webp" style="border-radius: 8px;" >}}

## Lobby

La map dispose d'un Lobby. Dans ce dernier, il est possible de consulter un livre contenant toutes les tentatives des joueurs avec diverses informations : le nombre de mobs tués, le nombre de salles ouvertes, le nombre de boss vaincus. Vous pouvez également vous entraîner à faire un peu de parkour, ou en bonus, tester le piano :smile:

{{< image src="/img/posts/serveur-minecraft-infinity-dungeon/lobby.webp" style="border-radius: 8px;" >}}

## Relancer une partie

Si une partie a déjà été jouée, il est nécessaire de réinitialiser la zone. Il suffit de cliquer sur le message dans le chat lorsque vous tentez d'entrer dans la zone principale.

{{< image src="/img/posts/serveur-minecraft-infinity-dungeon/reset.webp" style="border-radius: 8px;" >}}

## Installation

Voici les configurations nécessaires pour héberger cette map.

Le fichier `docker-compose.yml` :

```yml
services:
  mcserver:
    image: docker.io/itzg/minecraft-server:latest
    container_name: mcserver
    hostname: mcserver
    env_file: mcserver.env
    cpus: 2
    mem_limit: 2G
    volumes:
      - /opt/mcserver:/data
    ports:
      - 25565:25565
    tty: true
    stdin_open: true
    restart: always
```
Et son fichier de configuration `mcserver.env` :

```txt
UID=1000
GID=1000
TZ=Europe/Paris
EULA=true
OVERRIDE_SERVER_PROPERTIES=true
STOP_SERVER_ANNOUNCE_DELAY=10
MOTD=Infinity Dungeon Server
ENABLE_ROLLING_LOGS=true
TYPE=vanilla
VERSION=1.21
SNOOPER_ENABLED=false
MAX_PLAYERS=6
DIFFICULTY=easy
VIEW_DISTANCE=8
SIMULATION_DISTANCE=8
MAX_WORLD_SIZE=10000
SPAWN_PROTECTION=0
ENABLE_COMMAND_BLOCK=true
SEED=
LEVEL=world
ALLOW_NETHER=false
PVP=false
MODE=adventure
FORCE_GAMEMODE=true
HARDCORE=false
OPS=
WHITELIST=
ENFORCE_WHITELIST=false
NETWORK_COMPRESSION_THRESHOLD=128
PLAYER_IDLE_TIMEOUT=0
MEMORY=2G
ENABLE_RCON=false
RCON_PASSWORD=
ONLINE_MODE=true
ENFORCE_SECURE_PROFILE=true
```

Quelques points importants : 
- le mode de jeu est en `adventure`. De ce fait, la protection par whitelist n'est pas nécessaire, rien ne peut être détruit par les joueurs.
- Le serveur est en vanilla, forcé en 1.21, pour être 100% compatible avec version de la map, mise à jour très récemment.
- Les réglages préconisés par la map sont en place : difficulté en `easy`, nether désactivé, command-block activés...
- La map téléchargée sur [ce lien](https://www.planetminecraft.com/project/infinity-dungeons/) sera à décompresser sous `/opt/mcserver` avec comme nom de dossier `world`.
- La distance d'affichage est réglée sur 8. La map n'ayant pas de très grandes zones, il n'est pas utile de solliciter la charge serveur pour rien.
