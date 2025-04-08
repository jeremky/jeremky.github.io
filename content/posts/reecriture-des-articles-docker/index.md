---
title: Réécriture des articles au sujet de Docker
date: 2024-10-07T10:38:36+02:00
cover: /posts/reecriture-des-articles-docker/cover.webp
tags:
  - infos
  - docker
  - podman
categories:
  - News
toc: false
draft: false
---

J'ai récemment écrit [un article](/posts/migration-de-docker-vers-podman/) au sujet de ma migration de Docker vers Podman. Les différences entre ces 2 solutions sont minimes, mais elles nécessitent 2 ou 3 ajustements au niveau des fichiers `docker-compose.yml` pour être 100% compatibles. C'est donc l'occasion de refaire un tour sur les différents articles de ce site qui concernent la mise en place d'applications via un système de conteneurs.

## Variables

J'avais pris pour habitude d'utiliser un maximum de variables pour les définitions de certains éléments dans le fichier `docker-compose.yml`. Cela pouvait concerner les ports d'écoute, les chemins des volumes persistant... Mais à l'usage, cela n'a pas vraiment d'intérêt, sachant qu'en plaçant ces variables dans le fichier `.env` associé, elles se retrouvaient chargées dans le conteneur, ce qui ne fait pas vraiment sens. L'idée était de pouvoir déployer plusieurs conteneurs ayant un fichier `docker-compose.yml` unique. Mais il suffit de dupliquer le dossier et c'est réglé.

## Fichiers .env

L'autre changement important, est dans l'appel des variables d'environnement utilisées par le conteneur lui même. Dans le cas où plusieurs conteneurs sont définis dans un seul fichier `docker-compose.yml`, ces variables étaient donc chargées dans tous les conteneurs. Et... En terme de sécurité, ce n'est pas génial (un mot de passe de base de donnée pouvait être chargé dans le front web par exemple). 

Désormais, lorsqu'il y a plusieurs conteneurs dans un fichier `docker-compose.yml`, il y aura donc un fichier `.env` par conteneur. L'appel de ce fichier se fait différemment, ce qui ne nécessite plus de lister les variables dans le fichier `docker-compose.yml`. Docker et Podman gèrent la liste des variables directement en lisant les fichiers `.env` comme des grands. 

Cela se présente de la façon suivante (ajout de l'entrée `env_file`) : 

```yml
services:
  mon-service:
    image: image
    container_name: conteneur
    hostname: conteneur
    env_file: conteneur.env
    volumes:
      - /volume:/volume
    ports:
      - 1234:1234
```

Je vous renvoie vers l'article de la création d'un serveur [Nextcloud](/posts/construire-son-cloud-avec-nextcloud/) qui illustre bien ce changement.

## Mode restart

Lorsque l'on arrête ou redémarre notre serveur, Docker conserve l'état des conteneurs à l'extinction. Le mode `unless-stopped` permet donc de ne pas relancer les conteneurs que l'on avait manuellement arrêté sans les supprimer. Podman se comportant différemment, il considère que les conteneurs se sont correctement arrêtés et donc ne les relance pas au boot de la machine. Passer en mode `always` règle donc le souci. Attention cependant, vos conteneurs arrêtés manuellement seront relancés également.

A noter également que si vous voulez profiter de la mise à jour automatique, il est préférable de supprimer complètement la ligne `restart:`, et de passer par systemd pour le démarrage de vos conteneurs. 

> Le script [jdocker.sh](/posts/migration-de-docker-vers-podman/#jdockersh) est configuré pour fonctionner de cette façon.

## Nouveau tag

Comme indiqué dans l'article au sujet de la migration, un tag [#podman](/tags/podman/) a été ajouté au site pour différencier les tutos à jour. Une première passe a déjà été faite, mais je vérifierai de nouveau au cas où une coquille se serait glissée quelque part.

## Conclusion

Vous pouvez désormais suivre les tutos de ce site, peu importe l'application de conteneurisation que vous décidez d'utiliser. Je n'ai toutefois pas testé toutes les applications depuis ma migration, mais je ferai les mises à jour nécessaires sur ce site en fonction si nécessaire.
