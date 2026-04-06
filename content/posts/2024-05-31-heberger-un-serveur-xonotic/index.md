---
title: "Héberger un serveur Xonotic"
slug: heberger-un-serveur-xonotic
date: 2024-05-31T17:21:09Z
useRelativeCover: true
cover: cover.webp
tags:
  - jeux
  - docker
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

Une fois le serveur démarré, ce dernier va créer l'arborescence des fichiers nécessaires dans le sous dossier `./files`. Vous devrez y créer un fichier de configuration nommé `server.cfg` dans le sous dossier `data`. Voici un exemple que vous pouvez utiliser comme point de départ :

{{< code language="txt" title="Fichier server.cfg" id="1" expand="Afficher" collapse="Cacher" isCollapsed="true" >}}
/////////////////////////////////////////////////////////////////////
// SERVER

sv_public 1
sv_status_privacy 1
hostname "Xonotic $g_xonoticversion Server"
maxplayers 8
port 26000
log_file "server.log"

//rcon_password ""
//rcon_restricted_password ""


/////////////////////////////////////////////////////////////////////
// GAME

gametype dm

g_maplist_shuffle 1
g_maplist_mostrecent_count 3
g_maplist_check_waypoints 1
g_spawnshieldtime 3

fraglimit_override 30
timelimit_override -1

skill 4
minplayers 4
bot_prefix [BOT]

g_maplist_votable 6
sv_vote_call 1

//g_instagib 1
//g_weapon_stay 1
//g_powerups -1

/////////////////////////////////////////////////////////////////////
// PRIVACY

sv_weaponstats_file http://www.xonotic.org/weaponbalance/
{{< /code >}}

Si vous voulez une version complète du fichier, il est [disponible ici](https://github.com/xonotic/xonotic/blob/master/server/server.cfg).

Une fois le fichier créé, on redémarre le conteneur pour prise en compte :

```bash
sudo docker restart xonotic
```

Bons frags ! :sunglasses:
