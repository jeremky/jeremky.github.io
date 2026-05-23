---
title: "Images personnalisées"
slug: images-personnalisees
contextMenu: true
weight: 3
toc: true
tags:
  - docker
draft: false
lastmod: 2026-05-17
---

Il est possible de créer des images personnalisées à partir d'une image préexistante. Nous allons voir ici comment créer rapidement une image.

> Je ne fais référence qu'à Docker pour une question de lisibilité, mais cela est tout aussi valable pour Podman

## Fichier Dockerfile

Pour créer une image personnalisée, vous devez spécifier les instructions dans un fichier nommé `Dockerfile`.

Je ne vais pas réinventer la roue sur ce coup, je vous laisse aller voir la documentation faite par [OpenClassrooms](https://openclassrooms.com/fr/courses/2035766-optimisez-votre-deploiement-en-creant-des-conteneurs-avec-docker/6211517-creez-votre-premier-dockerfile) qui explique tout ça très bien.

Cette documentation vous présentera chaque instruction disponible que l'on peut utiliser dans le fichier `Dockerfile`, ainsi que les commandes Docker pour la génération de l'image une fois votre fichier prêt.

## Déployer avec Compose

Après avoir suivi leur documentation, vous devriez être en mesure de savoir comment construire une image avec les commandes Docker. Nous allons donc maintenant voir comment intégrer la construction directement dans un fichier `docker-compose.yml`, afin d'automatiser l'installation d'un conteneur depuis une image modifiée.
Vous n'aurez donc plus à passer par les étapes de build avant le déploiement de votre application.

Comme exemple, je vais prendre le cas de l'intégration de Hugo dans l'image de VS Code. Voici le fichier `docker-compose.yml` modifié en conséquence :

```yml {filename="docker-compose.yml"}
services:
  vscode:
    build: .
    context: .
    image: localhost/vscode-hugo:latest
    container_name: vscode
    hostname: vscode
    env_file: vscode.env
    networks:
      - nginx_proxy
    volumes:
      - /opt/containers/vscode:/config
      - /opt/containers/code-server/workspace:/config/workspace
    restart: always

networks:
  nginx_proxy:
    external: true
```

Et son fichier `Dockerfile` associé, à placer dans le même dossier :

```docker
FROM lscr.io/linuxserver/code-server:latest
RUN apt-get update && apt-get install -y hugo
```

L'image personnalisée sera alors automatiquement créée si elle n'est pas trouvée dans Docker. A l'inverse, Docker ne fera pas de build si l'image portant le nom spécifié dans le fichier `docker-compose.yml` est déjà présent dans sa base d'images.

Une fois votre application déployée, vous pourrez supprimer l'image d'origine, celle-ci ne sera pas automatiquement supprimée par le déploiement.
