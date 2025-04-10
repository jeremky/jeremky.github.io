---
title: "Bookstack : solution open source de documentation"
slug: bookstack-solution-open-source-de-documentation
date: 2025-04-09T18:32:22+02:00
useRelativeCover: true
cover: cover.webp
tags:
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: true
---

[Bookstack](https://www.bookstackapp.com/) est une plateforme open source, auto-hébergée et facile à utiliser pour organiser et stocker des informations. Développée en PHP avec le framework Laravel, elle est publiée sous licence MIT. BookStack structure le contenu en utilisant des étagères, des livres, des chapitres et des pages, offrant ainsi une organisation claire et intuitive.  ￼ ￼ ￼

L’interface de BookStack est conçue pour être simple et conviviale, avec un éditeur WYSIWYG qui facilite la création et la gestion du contenu. De plus, la plateforme est multilingue et disponible en plus de 30 langues.

## Installation

Pour l'installation, comme à chaque fois, nous avons un fichier `compose.yml` :

```yml
services:
  bookstack-db:
    image: lscr.io/linuxserver/mariadb
    container_name: bookstack-db
    hostname: bookstack-db
    env_file: bookstack-db.env
    networks:
      - default
    volumes:
      - /opt/bookstack/mysql:/config
    restart: always

  bookstack:
    image: lscr.io/linuxserver/bookstack
    container_name: bookstack
    hostname: bookstack
    env_file: bookstack.env
    networks:
      - default
      - nginx_proxy
    volumes:
      - /opt/bookstack/app:/config
    depends_on:
      - bookstack-db
    restart: always

networks:
  nginx_proxy:
    external: true
  default:
    external: false
```

Les variables se répartissent dans 2 fichiers `.env`. 1 pour le conteneur mariadb et un pour l'application elle-même.

Le fichier `bookstack-db.env` :

```txt
PUID=1000
PGID=1000
TZ=Europe/Paris
MYSQL_ROOT_PASSWORD=PASSWORD
MYSQL_DATABASE=bookstackapp
MYSQL_USER=bookstack
MYSQL_PASSWORD=PASSWORD
```

Et le fichier `bookstack.env` :

```txt
PUID=1000
PGID=1000
TZ=Europe/Paris
APP_URL=https://bookstack.mondomaine.fr
APP_LANG=fr
DB_HOST=bookstack-db
DB_PORT=3306
DB_USERNAME=bookstack
DB_PASSWORD=PASSWORD
DB_DATABASE=bookstackapp
APP_KEY=
#MAIL_DRIVER=smtp
#MAIL_HOST=
#MAIL_PORT=25
#MAIL_FROM=
#MAIL_FROM_NAME=
#DRAWIO=https://draw.mondomaine.fr/?embed=1&proto=json&spin=1&configure=1
```

Avant de lancer le déploiement de votre fichier `compose.yml`, vous devez générer une clé pour la variable `APP_KEY`. Pour cela, dans votre terminal : 

```bash
sudo docker run -it --rm --entrypoint /bin/bash lscr.io/linuxserver/bookstack:latest appkey
```

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisés avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) propose un fichier sample de configuration, il vous suffit juste de modifier votre nom de domaine en conséquence :

```bash
sudo cp /opt/nginx/nginx/proxy-confs/bookstack.subdomain.conf.sample /opt/nginx/nginx/proxy-confs/bookstack.subdomain.conf
sudo sed -i "s,server_name bookstack,server_name <votre_sous_domaine>,g" /opt/nginx/nginx/proxy-confs/bookstack.subdomain.conf
```

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Connexion

Une fois vos conteneurs déployés, vous pouvez vous rendre à l'adresse que vous avez défini. Vous allez tomber sur la page de connexion :

{{< image src="init.webp" style="border-radius: 8px;" >}}

Par défaut, les informations de connexion sont les suivantes :
- admin@admin.com
- password

{{< image src="home.webp" style="border-radius: 8px;" >}}

## Configuration

bla bla bla

## Rédaction

bla bla

## Conclusion

bla bla
