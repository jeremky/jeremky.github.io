---
title: "Watchtower : un conteneur pour les gouverner tous"
slug: watchtower-un-conteneur-pour-les-gouverner-tous
date: 2024-06-25T17:28:32Z
useRelativeCover: true
cover: cover.webp
tags:
  - admin
  - docker
categories:
  - Tutos
toc: false
draft: false
---

Docker est un outil incroyable qui permet de déployer facilement tout un tas de solutions logicielles. Grâce à lui, pas besoin de vous soucier de l'OS, de sa version, et des risques d'une mauvaise installation à cause des différentes opérations manuelles à effectuer, le tout étant déjà préparé dans les images que vous déployez.

De plus, lorsque vous êtes amené à mettre vos applications à jour, vous pouviez être confronté à effectuer des opérations fastidieuses. Grâce à Docker, il suffit de récupérer la dernière version d’une image et le tour est joué.

Mais... Imaginez qu'il soit possible de ne plus avoir à vous préoccuper même de ces opérations de mise à jour d’image, afin d’avoir automatiquement vos conteneurs à jour. C’est là que Watchtower intervient.

## Fonctionnalités

[Watchtower](https://containrrr.dev/watchtower/) est un outil capable de vérifier les images actuellement utilisées sur votre instance Docker. En fonction de la façon dont vous le configurez, il peut soit vous notifier que des nouvelles versions d'image sont disponibles, soit les mettre à jour automatiquement, en choisissant une fréquence de vérification, ou une date et heure précise.

C'est cette seconde méthode que je vais vous proposer de mettre en place, afin de redémarrer automatiquement sur la dernière version vos conteneurs à une heure désirée.

## Installation

Pour installer Watchtower, comme d'habitude, on commence par un fichier `docker-compose.yml` :

```yml
services:
  watchtower:
    image: containrrr/watchtower:latest
    container_name: watchtower
    hostname: watchtower
    privileged: true
    env_file: watchtower.env
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
```

Et son fichier `watchtower.env` :

```bash
TZ=Europe/Paris

WATCHTOWER_SCHEDULE=0 0 6 * * *
WATCHTOWER_LABEL_ENABLE=false
WATCHTOWER_CLEANUP=true
WATCHTOWER_REMOVE_VOLUMES=true
#WATCHTOWER_DISABLE_CONTAINERS=
```

Petit tour des variables que j’utilise :

- `WATCHTOWER_SCHEDULE` : permet de définir le moment du check à la manière de cron. Tous les jours à 6h dans notre exemple
- `WATCHTOWER_LABEL_ENABLE` : il est par défaut nécessaire d'indiquer dans chaque fichier `docker-compose.yml` si le conteneur doit être vérifié. Désactivé dans notre cas pour plus de simplicité
- `WATCHTOWER_CLEANUP` : nettoie ou non les anciennes images une fois la mise à jour effectuée
- `WATCHTOWER_REMOVE_VOLUMES` : supprime les volumes qui ne sont pas nommés
- `WATCHTOWER_DISABLE_CONTAINERS` : permet lister les conteneurs à exclure de la vérification (séparé par des espaces)

Si vous avez besoin de précisions sur ces paramètres, les infos se trouvent principalement [ici](https://containrrr.dev/watchtower/arguments/).

Petite capture des logs d'une instance en place, avec deux exemples d'images mises à jour :

{{< image src="logs.webp" style="border-radius: 8px;" >}}
