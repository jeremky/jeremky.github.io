---
title: "Hytale"
slug: hytale
contextMenu: true
weight: 10
toc: true
tags:
  - jeux
  - docker
draft: true
lastmod: 2026-06-06
---

_[Hytale](https://fr.wikipedia.org/wiki/Hytale) est un jeu vidéo de type sandbox développé et édité par Hypixel Studios (équipe à l’origine du serveur Minecraft Hypixel), sorti en accès anticipé le 13 janvier 2026 sur Windows, Mac et Linux._

_Le développement du jeu a débuté en 2015. Son annonce officielle a eu lieu fin 2018, accompagnée d'une bande-annonce sur YouTube qui a cumulé plus de 60 millions de vues. Initialement annoncé pour une sortie en 2021, le jeu a été racheté par Riot Games, repoussé plusieurs fois, abandonné en juin 2025, puis racheté en novembre 2025 par Simon Collins, co-créateur du studio et fondateur d'Hypixel._
_Hytale est fondé sur un système de construction par blocs inspiré de Minecraft, tout en restant totalement indépendant._

![logo](logo.webp)

## Installation

Après pas mal de recherche, j'ai finalement trouvé une image Docker simple à déployer, et surtout stable dans son approche. La page du créateur est disponible [ici](https://github.com/romariin/hytale-docker).

Le fichier `docker-compose.yml` :

{{< tabs >}}
{{< tab name="Docker" >}}

```yml {filename="docker-compose.yml"}
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

{{< /tab >}}
{{< tab name="Podman" >}}

```yml {filename="docker-compose.yml"}
services:
  hytale:
    image: docker.io/rxmarin/hytale-docker:latest
    container_name: hytale
    hostname: hytale
    user: 0:0
    env_file: hytale.env
    stdin_open: true
    tty: true
    volumes:
      - /opt/containers/hytale:/server
    ports:
      - 5520:5520/udp
    restart: always
```

{{< /tab >}}
{{< /tabs >}}

Le fichier `hytale.env` associé :

```ini {filename="hytale.env"}
TZ=Europe/Paris
SERVER_PORT=5520
AUTO_UPDATE=true
DISABLE_SENTRY=true
FORCE_UPDATE=false
```

> Avec ces variables, on désactive notamment la télémétrie, et on s'assure que le serveur se mettra à jour à chaque redémarrage du conteneur

## Configuration

Le serveur Hytale a besoin d'un compte valide pour démarrer. Au 1er lancement, une URL vous sera indiquée, ainsi qu'un code à saisir que vous obtiendrez une fois connecté à votre compte.

### Initialisation

{{% steps %}}

#### Consultez les logs de votre conteneur

{{< tabs >}}
{{< tab name="Docker" >}}

```bash
docker logs -f hytale
```

{{< /tab >}}
{{< tab name="Podman" >}}

```bash
podman logs -f hytale
```

{{< /tab >}}
{{< /tabs >}}

![logs](logs.webp)

#### Rendez-vous au lien affiché

![autorisation](autorisation.webp)

#### Autorisez l'appareil

![validation](validation.webp)

#### Vérifiez de nouveau les logs

![download](download.webp)

L'autorisation est terminée, le serveur procède au téléchargement des fichiers nécessaires.

{{% /steps %}}

### Firewall

Hytale utilise le port 5520 en UDP pour fonctionner. Si vous utilisez UFW :

```bash
sudo ufw allow 5520/udp
```
