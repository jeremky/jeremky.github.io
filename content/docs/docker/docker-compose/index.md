---
title: "Docker Compose"
slug: docker-compose
contextMenu: true
weight: 2
toc: true
tags:
  - docker
draft: false
lastmod: 2026-05-17
---

_[Docker Compose](<https://fr.wikipedia.org/wiki/Docker_(logiciel)>) est un logiciel pour définir et exécuter des applications à partir de multiples conteneurs. Il est basé sur un fichier YAML qui permet de définir les services et les paramètres de leurs créations et ainsi de les démarrer par une commande unique. La V1 avait son propre exécutable (docker-compose) alors que la V2 est un plugin de Docker, exécutable par la commande docker compose_

## Exemple d'un fichier docker-compose

Comme dit dans l'introduction, il est possible de déployer plusieurs conteneurs dans un seul projet. Dans ce fichier, nommé `docker-compose.yml`, vous pouvez y définir confortablement les paramètres et variables d'environnement de vos conteneurs. Comme exemple, nous allons prendre celui de Nextcloud, composé de l'application web elle-même, et de la base de données :

```yml {filename="docker-compose.yml"}
services:
  nextcloud-db:
    image: docker.io/postgres:16.4
    container_name: nextcloud-db
    hostname: nextcloud-db
    networks:
      - default
    env_file: nextcloud-db.env
    volumes:
      - /opt/containers/nextcloud/postgres:/var/lib/postgresql/data
    restart: always

  nextcloud-web:
    image: lscr.io/linuxserver/nextcloud:latest
    container_name: nextcloud-web
    hostname: nextcloud-web
    env_file: nextcloud.env
    volumes:
      - ${DIRECTORY}/config:/config
      - ${DIRECTORY}/data:/data
    ports:
      - ${HTTPPORT}:80
      - ${HTTPSPORT}:443
    depends_on:
      - nextcloud-db
    restart: always
```

Les éléments clés :

- La définition des services, avec son nom, l'image utilisée, et le nom du conteneur
- env_file : spécifie le nom du fichier où seront stockées les variables utilisées par le conteneur (que nous allons voir plus loin dans cet article)
- volumes : se sont les répertoires partagés entre votre machine hôte et votre conteneur
- ports : les ports qui seront ouverts entre l'hôte et le conteneur. Vous remarquerez que pour la base mysql, le port n'a pas été ouvert. Mais ces 2 conteneurs seront dans le même réseau virtuel et le conteneur nextcloud-web pourra contacter la base via son hostname nextcloud-db
- restart : défini le comportement du conteneur en cas de crash par exemple

> Les images utilisées sont celles de [Linuxserver.io](https://www.linuxserver.io/)

## Le fichier de variables .env

En plus de votre fichier `docker-compose.yml`, vous devez y associer un fichier contenant les variables que va utiliser compose. Il est possible d'intégrer les valeurs directement dans le fichier yml, mais cela permet une meilleure flexibilité.
Par défaut, il va chercher un fichier nommé `.env`. Mais il est possible de lui spécifier nous même le fichier grâce à l'entrée `env_file`.

Toujours pour notre exemple avec Nextcloud, voici le contenu :

Fichier `nextcloud-db.env` :

```ini {filename="nextcloud-db.env"}
POSTGRES_PASSWORD=Password
POSTGRES_USER=nextcloud
POSTGRES_DB=nextcloud
```

Fichier `nextcloud.env` :

```ini {filename="nextcloud.env"}
PUID=1002
PGID=1002
TZ=Europe/Paris
```

Les variables dépendent de la façon dont a été constituée l'image Docker. Celles de Linuxserver offrent la possibilité de spécifier l'ID du user hôte et le timezone, pratique. Au sujet des variables de port, spécifier l'IP devant permet de forcer à utiliser uniquement l'IP V4.

## Déploiement

Maintenant que vous avez vos 2 fichiers, il ne reste plus qu'à déployer ! Pour cela, lancez la commande suivante (il est nécessaire d'être dans le répertoire où se trouvent vos 2 fichiers) :

```bash
sudo docker-compose up -d
```

Docker va télécharger les images et procéder au déploiement. Votre instance Nextcloud devrait maintenant être accessible.

Si vous voulez supprimer vos conteneurs :

```bash
sudo docker-compose down
```

A noter que cela ne supprime ni les images, ni les répertoires partagés (dans notre cas, `/opt/containers/nextcloud`).
