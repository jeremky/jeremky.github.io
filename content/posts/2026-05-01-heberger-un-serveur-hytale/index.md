---
title: "Héberger un serveur Hytale"
slug: heberger-serveur-hytale
date: 2026-05-01T12:34:37+02:00
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

D'après [Wikipedia](https://fr.wikipedia.org/wiki/Hytale), _[Hytale](https://hytale.com) est un jeu vidéo de type sandbox développé et édité par Hypixel Studios (équipe à l’origine du serveur Minecraft Hypixel), sorti en accès anticipé le 13 janvier 2026 sur Windows, Mac et Linux._
_Le développement du jeu a débuté en 2015. Son annonce officielle a eu lieu fin 2018, accompagnée d'une bande-annonce sur YouTube qui a cumulé plus de 60 millions de vues. Initialement annoncé pour une sortie en 2021, le jeu a été racheté par Riot Games, repoussé plusieurs fois, abandonné en juin 2025, puis racheté en novembre 2025 par Simon Collins, co-créateur du studio et fondateur d'Hypixel._
_Hytale est fondé sur un système de construction par blocs inspiré de Minecraft, tout en restant totalement indépendant._

Nous allons voir dans cet article comment déployer un serveur sur un système Debian/Ubuntu.

## Installation

Après pas mal de recherche, j'ai finalement trouvé une image Docker/Podman qui est simple à déployer. La page du créateur est disponible [ici](https://github.com/romariin/hytale-docker).

Le fichier `compose.yml` :

```yml
services:
  hytale:
    image: docker.io/rxmarin/hytale-docker:latest
    container_name: hytale
    hostname: hytale
    env_file: hytale.env
    stdin_open: true
    tty: true
    volumes:
      - /opt/containers/hytale:/server
    ports:
      - 5520:5520/udp
    restart: always
```

> Si vous utilisez Podman en rootless, ajoutez `user: 0:0` afin d'avoir les droits d'écriture

Son fichier `hytale.env` associé :

```txt
TZ=Europe/Paris
SERVER_PORT=5520
AUTO_UPDATE=true
DISABLE_SENTRY=true
FORCE_UPDATE=false
```

> Avec ces variables, on désactive notamment la télémétrie, et on s'assure que le serveur se mettra à jour aux lancements suivants

## Configuration

Le serveur Hytale a besoin d'un compte valide pour démarrer. Au 1er lancement, une URL vous sera indiquée ainsi qu'un code à saisir une fois connecté à votre compte depuis votre poste.

Consultez les logs de votre conteneur :

```bash
docker logs -f hytale
```

Ou si vous utilisez Podman :

```bash
podman logs -f hytale
```

## Firewall

Hytale utilise le port 5520 en UDP pour fonctionner. Si vous utilisez UFW :

```bash
sudo ufw allow 5520/udp
```

## Conclusion

Et voilà, votre serveur Hytale est prêt à être utilisé ! N'oubliez pas de consulter régulièrement les mises à jour du serveur pour bénéficier des dernières fonctionnalités et améliorations. Amusez-vous bien !
