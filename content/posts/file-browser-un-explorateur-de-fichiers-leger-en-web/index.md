---
title: "File Browser : un explorateur de fichiers léger en web"
slug: file-browser-un-explorateur-de-fichiers-leger-en-web
date: 2024-06-06T17:21:58Z
useRelativeCover: true
cover: cover.webp
tags:
  - fichiers
  - docker
categories:
  - Tutos
toc: true
draft: false
---

Il existe différentes solutions pour accéder à des fichiers sur un système.
Nous avons le plus simple, le partage Windows (samba), mais limité au réseau local.
Une autre solution efficace, c’est le FTP ou le SFTP, très pratique, mais pas
vraiment confortable, et fastidieux pour du partage de fichiers à d'autres utilisateurs.
A la place, je vous propose un logiciel qui fait parfaitement le job :
[File Browser](https://github.com/filebrowser/filebrowser).

## Interface

L'interface se veut très légère, afin d'aller à l'essentiel. Vous accédez directement
aux dossiers et fichiers présents sur le système (contrairement à Nextcloud par
exemple qui possède sa propre arborescence).

Beaucoup de fonctionnalités sont présentes :

- Le téléchargement d'un dossier en archive compressée
- Une visualisation des images
- Un éditeur de texte
- Un lanceur de commandes système (peu utile dans le cas d'une installation Docker)
- La possibilité de partager simplement du contenu, avec durée, et protection
par mot de passe

{{< image src="filebrowser1.webp" style="border-radius: 8px;" >}}
***
{{< image src="filebrowser2.webp" style="border-radius: 8px;" >}}
***
{{< image src="filebrowser3.webp" style="border-radius: 8px;" >}}
***
{{< image src="filebrowser4.webp" style="border-radius: 8px;" >}}

## Installation

Cela devient redondant, mais encore une fois, c'est via Docker que nous
installerons cet outil.

Le fichier `docker-compose.yml` :

```yml
services:
  filebrowser:
    image: docker.io/filebrowser/filebrowser
    container_name: filebrowser
    hostname: filebrowser
    user: 1000:1000
    networks:
      - nginx_proxy
    volumes:
      - ./files/database:/database
      - ./files/config:/config
      - ./files/branding:/branding
      - /home:/srv
    restart: always

networks:
  nginx_proxy:
    external: true
```

Quelques éléments à préciser :

- La partie `user` dans le fichier `docker-compose.yml` est à adapter selon l'ID
de votre utilisateur. Mettez `0:0` si vous utilisez Podman
- Il est nécessaire de créer un dossier `files` là où se trouve votre fichier compose
- Dans ce dossier, vous devrez créer un sous dossier `database`, avec à l'intérieur
un fichier vide nommé `filebrowser.db` (qui comme son nom l'indique, servira
de base de données)
- Enfin, il vous faut créer dans ce même dossier `files` un sous dossier `config`,
avec à l'intérieur un fichier nommé `settings.json` pour y insérer le
contenu suivant :

```bash
{
  "port": 8080,
  "baseURL": "",
  "address": "",
  "log": "stdout",
  "database": "/database/filebrowser.db",
  "root": "/srv"
}
```

### Reverse proxy

Afin d'accéder à votre application fraîchement installée, je vous conseille
d'utiliser un reverse proxy pour plus de sécurité.

> Pour rappel, un article dédié est disponible [ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/)
propose un fichier sample de configuration. Si votre reverse proxy est en place,
utilisez la commande suivante pour activer sa configuration :

```bash
sudo cp /opt/containers/nginx/nginx/proxy-confs/filebrowser.subdomain.conf.sample /opt/containers/nginx/nginx/proxy-confs/filebrowser.subdomain.conf
```

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Configuration

Dans la partie *Paramètres*, vous avez dans l'onglet *Paramètres généraux*, des
éléments à modifier, notamment le dossier par défaut qui sera utilisé lors de la
création d'un nouvel utilisateur, ses droits, mais également la possibilité de
créer un sous dossier directement par utilisateur.

{{< image src="filebrowser5.webp" style="border-radius: 8px;" >}}

## Conclusion

Quelques éléments et protocoles peuvent manquer à File Browser comparé à un outil
comme Nextcloud (le WebDAV, un client de synchronisation...). Mais ce n'est pas
l'objectif de cet outil, qui est de proposer une solution légère d'accès à
ses fichiers. Et si c'est seulement ce dont vous avez besoin, File Browser est
clairement une solution que je recommande chaudement.
