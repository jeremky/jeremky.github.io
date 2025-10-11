---
title: Personnaliser vos images Docker
slug: personnaliser-vos-images-docker
date: 2024-11-02T00:22:28.896Z
useRelativeCover: true
cover: cover.webp
tags:
  - docker
categories:
  - Tutos
toc: true
draft: false
---

Les tutos présents sur ce site pour l'installation d'applications via [Docker](/posts/premiers-pas-avec-docker/)
utilisent des images disponibles directement sur [Dockerhub](https://hub.docker.com/).
Les images étant fonctionnelles en l'état, je n'ai jamais eu besoin de construire
moi-même une image.

L'utilisation de [VS Code](/posts/visual-studio-code-dans-son-navigateur/) m'a
poussé à regarder comment transformer l'image créée par [linuxserver.io](https://hub.docker.com/r/linuxserver/code-server)
pour y ajouter Hugo, sans avoir besoin de réinstaller l'application à chaque redéploiement.

> Dans cet article, je ne fais référence qu'à Docker pour une question de lisibilité,
mais cela est tout aussi valable pour Podman

## Fichier Dockerfile

Pour créer une image personnalisée, vous devez spécifier les instructions dans
un fichier nommé `Dockerfile`.

Je ne vais pas réinventer la roue sur ce coup, je vous laisse aller voir la documentation
faite par [OpenClassrooms](https://openclassrooms.com/fr/courses/2035766-optimisez-votre-deploiement-en-creant-des-conteneurs-avec-docker/6211517-creez-votre-premier-dockerfile)
qui explique tout ça très bien.

Cette documentation vous présentera chaque instruction disponible que l'on peut
utiliser dans le fichier `Dockerfile`, ainsi que les commandes Docker pour la
génération de l'image une fois votre fichier prêt.

## Déployer avec Compose

Après avoir suivi leur documentation, vous devriez être en mesure de savoir comment
construire une image avec les commandes Docker. Nous allons donc maintenant voir
comment intégrer la construction directement dans un fichier `docker-compose.yml`,
afin d'automatiser l'installation d'un conteneur depuis une image modifiée.
Vous n'aurez donc plus à passer par les étapes de build avant le déploiement
de votre application.

Comme exemple, je vais prendre le cas de l'intégration de Hugo dans l'image
de VS Code. Voici le fichier `docker-compose.yml` modifié en conséquence :

```yml
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

L'image personnalisée sera alors automatiquement créée si elle n'est pas trouvée
dans Docker. A l'inverse, Docker ne fera pas de build si l'image portant le nom
spécifié dans le fichier `docker-compose.yml` est déjà présent dans sa base d'images.

Une fois votre application déployée, vous pourrez supprimer l'image d'origine,
celle-ci ne sera pas automatiquement supprimée par le déploiement.

## Conclusion

J'ai pris pas mal de temps avant de parler de cet aspect de Docker. Et encore,
j'ai vraiment survolé le sujet, et j'ai surtout orienté cet article selon
mes propres besoins. J'ajouterai peut être certains éléments à l'avenir si je
suis de nouveau confronté à des besoins similaires.
