---
title: "Bookstack : solution open source de documentation"
slug: bookstack-solution-open-source-de-documentation
date: 2025-04-12T23:39:33.556Z
useRelativeCover: true
cover: cover.webp
tags:
  - docker
categories:
  - Tutos
toc: true
draft: false
---

[Bookstack](https://www.bookstackapp.com/) est une plateforme open source, auto-hébergée
et facile à utiliser pour organiser et stocker des informations. Développée en PHP
avec le framework Laravel, elle est publiée sous licence MIT. BookStack structure
le contenu en utilisant des étagères, des livres, des chapitres et des pages,
offrant ainsi une organisation claire et intuitive.

L’interface de BookStack est conçue pour être simple et conviviale, avec un éditeur
WYSIWYG qui facilite la création et la gestion du contenu. De plus, la plateforme
est multilingue et disponible en plus de 30 langues.

## Installation

Pour l'installation, comme à chaque fois, nous avons un fichier
`docker-compose.yml` :

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
      - /opt/containers/bookstack/mysql:/config
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
      - /opt/containers/bookstack/app:/config
    depends_on:
      - bookstack-db
    restart: always

networks:
  nginx_proxy:
    external: true
  default:
    external: false
```

Les variables se répartissent dans 2 fichiers `.env` : un pour le conteneur mariadb
et un pour l'application elle-même.

Le fichier `bookstack-db.env` :

```bash
PUID=1000
PGID=1000
TZ=Europe/Paris
MYSQL_ROOT_PASSWORD=PASSWORD
MYSQL_DATABASE=bookstackapp
MYSQL_USER=bookstack
MYSQL_PASSWORD=PASSWORD
```

Et le fichier `bookstack.env` :

```bash
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
MAIL_DRIVER=smtp
MAIL_HOST=
MAIL_PORT=25
MAIL_FROM=
MAIL_FROM_NAME=
```

Avant de lancer le déploiement de votre fichier `docker-compose.yml`, vous devez
générer une clé pour la variable `APP_KEY`. Pour cela, dans votre terminal :

```bash
sudo docker run -it --rm --entrypoint /bin/bash lscr.io/linuxserver/bookstack:latest appkey
```

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisés avec un
reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/)
propose un fichier sample de configuration, il vous suffit juste de modifier votre
nom de domaine en conséquence :

```bash
sudo cp /opt/containers/nginx/nginx/proxy-confs/bookstack.subdomain.conf.sample /opt/containers/nginx/nginx/proxy-confs/bookstack.subdomain.conf
sudo sed -i "s,server_name bookstack,server_name <votre_sous_domaine>,g" /opt/containers/nginx/nginx/proxy-confs/bookstack.subdomain.conf
```

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Connexion

Une fois vos conteneurs déployés, vous pouvez vous rendre à l'adresse que vous
avez défini. Vous allez tomber sur la page de connexion :

{{< image src="init.webp" style="border-radius: 8px;" >}}

Par défaut, les informations de connexion sont les suivantes :
- admin@admin.com
- password

{{< image src="home.webp" style="border-radius: 8px;" >}}

## Configuration

Une fois connecté, Vous allez pouvoir vous rendre dans les préférences en haut à
droite de l'interface. L'interface, suffisamment claire, va vous permettre d'effectuer
les réglages suivantes :

- Personnalisation du design, en changeant le logo, les couleurs...
- Création / Modification des utilisateurs, et des différents roles
- Maintenance de l'application

Commencez par modifier les informations de l'utilisateur admin de base pour y
changer l'adresse email et le mot de passe :

{{< image src="profil.webp" style="border-radius: 8px;" >}}

## Rédaction

Bookstack dispose d'une logique particulière pour le tri de la documentation.
Au lieu de fonctionner par thème, catégorie, Il repose sur une logique
"physique" : étagères, livres, chapitres, et pages.
Commencez donc par créer votre 1ère étagère :

{{< image src="etagere.webp" style="border-radius: 8px;" >}}

Répétez l'opération pour créer votre 1er livre. Vous aurez ensuite le choix de créer
directement une page, ou de subdiviser via des chapitres. Pour la démo, nous allons
passer directement à la partie rédaction d'une page :

{{< image src="edition.webp" style="border-radius: 8px;" >}}

L'éditeur par défaut est WYSIWYG (pour What You See Is What You Get). Très facile
à prendre en main, mais si vous préférez rédiger en Markdown, c'est possible !

Une fois votre page rédigée, sachez qu'il est possible de l'exporter sous différents
formats, de consulter les révisions, ou de placer des commentaires :

{{< image src="export.webp" style="border-radius: 8px;" >}}

## Diagrammes

Petite précision au sujet des diagrammes. Bookstack se base sur l'excellent [Draw.io](https://www.drawio.com/)
en version web. Lorsque vous voulez ajouter un diagramme, vous allez être directement
redirigé vers [app.diagrams.net](https://app.diagrams.net) pour construire votre
diagramme.
Une fois que vous aurez cliqué sur `Enregister`, il sera placé sur votre page :

{{< image src="diagram.webp" style="border-radius: 8px;" >}}

Attention, il n'est à ma connaissance pas possible de modifier le diagramme à posteriori.

A noter qu'il est possible d'héberger une instance Draw.io et de la faire communiquer
avec Bookstack. Ce sera le sujet du prochain article.

## Conclusion

De part sa philosophie d'organisation et sa simplicité d'utilisation, Bookstack est
une excellente solution à envisager si vous avez besoin d'un lieu où stocker de
la documentation. De plus, il est libre, et facile à déployer. Je le recommande !
