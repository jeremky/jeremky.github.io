---
title: Créer son dashboard avec Heimdall
slug: creer-son-dashboard-avec-heimdall
date: 2024-07-25T20:40:43+02:00
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

[Heimdall](https://heimdall.site/) est une application web vous permettant d'y configurer votre dashboard personnalisé.

*"Heimdall⁠ est un moyen d'organiser de manière simple les liens vers vos sites Web et applications Web les plus utilisés.*
*La simplicité est la clé de Heimdall.*
*Pourquoi ne pas l'utiliser comme page de démarrage de votre navigateur ? Il a même la possibilité d'inclure une barre de recherche utilisant Google, Bing ou DuckDuckGo."*

Vous pouvez y créer vos propres applications sous forme de lien web, mais il est parfois possible d'avoir davantage d'interactions, afin d'y afficher des informations supplémentaires sous forme de widget.

Plus d'informations [sur leur site web](https://heimdall.site/).

{{< image src="website.webp" style="border-radius: 8px;" >}}

## Installation

Les fichiers nécessaires au déploiement de Heimdall sont les suivants :

Le fichier `compose.yml` :

```yml
services:
  heimdall:
    image: lscr.io/linuxserver/heimdall:latest
    container_name: heimdall
    hostname: heimdall
    env_file: heimdall.env
    networks:
      - nginx_proxy
    volumes:
      - /opt/heimdall:/config
    restart: always

networks:
  nginx_proxy:
    external: true
```

Et son fichier `heimdall.env` :

```bash
PUID=1000
PGID=1000
TZ=Europe/Paris
```

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisés avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) propose un fichier sample de configuration, il vous suffit juste de modifier votre nom de domaine en conséquence :

```bash
sudo cp /opt/nginx/nginx/proxy-confs/heimdall.subdomain.conf.sample /opt/nginx/nginx/proxy-confs/heimdall.subdomain.conf
sudo sed -i "s,server_name heimdall,server_name <votre_sous_domaine>,g" /opt/nginx/nginx/proxy-confs/heimdall.subdomain.conf
```

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Configuration

Une fois le déploiement terminé, vérifiez le bon fonctionnement de l'app dans votre navigateur :

{{< image src="default.webp" style="border-radius: 8px;" >}}

Commencez par vous rendre dans la partie `user` pour modifier l'utilisateur par défaut. Lui assigner un mot de passe désactivera l'accès public.

Vous pouvez ensuite vous rendre dans `settings` pour changer les paramètres de langue, le fond d'écran...

{{< image src="settings.webp" style="border-radius: 8px;" >}}

Une fois cela effectué, relancez votre navigateur, et votre conteneur via la commande :

```bash
sudo docker restart heimdall
```

{{< image src="login.webp" style="border-radius: 8px;" >}}

### Applications Web

Il est temps d'y ajouter vos applications. Après avoir cliqué sur le bouton `Liste des applications`, un bouton `ADD` se trouve en haut à droite. 
Vous pouvez lui spécifier quelle application parmi la liste, ou pointer directement sur un site web.

{{< image src="webapp.webp" style="border-radius: 8px;" >}}

### Applications améliorées

Vous trouverez la liste des applications disponibles [sur cette page](https://apps.heimdall.site/applications/enhanced). Téléchargez y l'application de votre choix et déposez le fichier zip dans le dossier `/opt/heimdall/config/www/SupportedApps`.

{{< image src="addapp.webp" style="border-radius: 8px;" >}}

Redémarrez ensuite Heimdall, toujours avec cette commande :

```bash
sudo docker restart heimdall
```

Vous pouvez maintenant ajouter votre application. Dans mon cas File Browser :

{{< image src="appconfig.webp" style="border-radius: 8px;" >}}

Une fois les paramètres de connexion renseignés, l'application affiche des informations extraites. 

## Conclusion 

Pas vraiment de conclusion pour cet article, mais un exemple de rendu :

{{< image src="example.webp" style="border-radius: 8px;" >}}

En espérant pour lui qu'il trouvera preneur parmi vous ! :sunglasses:
