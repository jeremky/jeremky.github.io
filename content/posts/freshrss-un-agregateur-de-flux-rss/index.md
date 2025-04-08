---
title: "FreshRSS : un agrégateur de flux RSS"
date: 2024-10-14T18:03:58+02:00
useRelativeCover: true
cover: cover.webp
tags:
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

FreshRSS est présenté sur [Wikipedia](https://fr.wikipedia.org/wiki/FreshRSS) comme "*un agrégateur de flux RSS, Atom Syndication Format et WebSub en ligne, sous licence libre GNU AGPL v32.*"

Pour celles et ceux qui seraient passés à côté, le *RSS (sigle venant de l'anglais Really Simple Syndication, litt. « syndication vraiment simple ») est une famille de Flux web, c'est-à-dire un type de formats de données utilisé pour la syndication de contenu Web.*

> *Un produit RSS est une ressource du World Wide Web dont le contenu est produit automatiquement (sauf cas exceptionnels) en fonction des mises à jour d’un site Web. Les flux RSS sont des fichiers XML qui sont souvent utilisés par les sites d'actualité et les blogs pour présenter les titres des dernières informations consultables.*

Petite capture de l'application présente sur le [site officiel](https://www.freshrss.org/) :

{{< image src="screenshot.webp" style="border-radius: 8px;" >}}

## Utilisation

Même si FreshRSS dispose d'une interface web dédiée pour consulter les articles, sa force est à mon sens sa compatibilité avec beaucoup d'applications mobile iOS/Android, mais aussi avec des applications Windows, MacOS et Linux.

Vous pourrez alors centraliser vos sources de news et les consulter indépendamment de l'appareil que vous voulez utiliser.

Pour vérifier quelles applications sont compatibles avec FreshRSS, je vous laisse aller voir directement sur leur [page Github](https://github.com/FreshRSS/FreshRSS). Ils y précisent si l'application est gratuite ou non, et si le développement est toujours en cours. 

## Installation

Pour installer FreshRSS, voici les fichiers Docker/Podman nécessaires : 

Le fichier `docker-compose.yml` :

```yml
services:
  freshrss:
    image: lscr.io/linuxserver/freshrss:latest
    container_name: freshrss
    hostname: freshrss
    env_file: freshrss.env
    networks:
      - nginx_proxy
    volumes:
      - /opt/freshrss/config:/config
    restart: always

networks:
  nginx_proxy:
    external: true
```

Et le fichier `freshrss.env` associé :

```txt
PUID=1000
PGID=1000
TZ=Europe/Paris
```

### Moteur SQL

A noter que cette configuration suppose que vous allez utilisez SQLite comme moteur de base de données. FreshRSS est compatible avec MariaDB et PosgreSQL. Si c'est pour de l'auto hébergement avec quelques utilisateurs, SQLite suffira largement. Mais dans le cas où vous voulez tout de même un autre moteur, je vous laisse voir l'article au sujet de [Nextcloud]() pour y trouver un équivalent de configuration avec PosgreSQL.

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisé avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) propose un fichier sample de configuration, il vous suffit juste de modifier votre nom de domaine en conséquence :

```bash
sudo cp /opt/nginx/nginx/proxy-confs/freshrss.subdomain.conf.sample /opt/nginx/nginx/proxy-confs/freshrss.subdomain.conf
sudo sed -i "s,server_name freshrss,server_name <votre_sous_domaine>,g" /opt/nginx/nginx/proxy-confs/freshrss.subdomain.conf
```

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Initialisation

Une fois FreshRSS déployé, vous pouvez ouvrir votre navigateur et y terminer l'installation :

{{< image src="init.webp" style="border-radius: 8px;" >}}

Il vous sera demandé de sélectionner la base à utiliser. Comme vu plus haut, nous allons faire simple et choisir SQLite : 

{{< image src="bdd.webp" style="border-radius: 8px;" >}}

Ensuite, saisissez votre nom d'utilisateur et votre mot de passe : 

{{< image src="user.webp" style="border-radius: 8px;" >}}

Une fois les différentes étapes effectuées, FreshRSS va vous renvoyer vers la page d'accueil :

{{< image src="accueil.webp" style="border-radius: 8px;" >}}

Il ne vous reste plus qu'à y ajouter les flux RSS de vos sites préférés !

J'en profite pour informer que ce site est compatible RSS, il vous suffit d'utiliser [ce lien](/posts/index.xml).

Bonne lecture !
