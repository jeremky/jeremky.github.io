---
title: "ddclient : synchroniser un domaine à son IP automatiquement"
date: 2024-06-22T17:25:42Z
cover: /posts/ddclient-synchroniser-un-domaine-a-son-ip-automatiquement/cover.webp
tags:
  - reseau
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

Lorsque vous hébergez un serveur à votre domicile, il est possible que vous soyez confronté à un problème : votre fournisseur d'accès ne vous attribue pas une IP publique fixe.
L'idée de cet article est donc de vous proposer une solution efficace pour obtenir gratuitement un nom de domaine, qui sera mis à jour automatiquement lorsque l'IP de votre box changera.

## Création d'un compte chez Dynu.com

Il existe plusieurs fournisseurs de nom de domaine dynamique. Toutefois, je recommande [Dynu](https://www.dynu.com/fr-FR/), qui propose une solution gratuite, et surtout qui ne nécessite pas de confirmer que l'on existe toujours tous les mois...
Vous créez votre compte, et vous allez dans *DDNS Services*. Vous cliquez ensuite sur le bouton *Ajouter* :

{{< image src="dynu1.webp" style="border-radius: 8px;" >}}

Vous pouvez alors choisir le nom qui vous intéresse parmi la liste des domaines. Une fois votre domaine créé, vous arrivez ici :

{{< image src="dynu2.webp" style="border-radius: 8px;" >}}

Maintenant, nous allons pouvoir installer un petit agent sur votre serveur afin d'envoyer les informations de façon régulière.

## Installation de ddclient

[ddclient](https://ddclient.net/) est un logiciel qui permet de mettre à jour son IP dynamiquement auprès de différents fournisseurs. Pour la suite de cet article, je vais considérer que vous avez créé un compte chez Dynu.

Pour l'installation, un fichier `docker-compose.yml` :

```yml
services:
  ddclient:
    image: lscr.io/linuxserver/ddclient:latest
    container_name: ddclient
    hostname: ddclient
    env_file: ddclient.env
    volumes:
      - ./files:/config
    restart: always
```

Et son fichier `ddclient.env` :

```txt
PUID=1000
PGID=1000
TZ=Europe/Paris
```

## Configuration

Dans le dossier où se trouvent vos fichiers, créez un répertoire `files`, et ajoutez y le fichier de config suivant, sous le nom `ddclient.conf` :

```txt
## ddclient configuration for Dynu
daemon=60                                                # Check every 60 seconds.
syslog=yes                                               # Log update msgs to syslog.
pid=/var/run/ddclient.pid                                # Record PID in file.
use=web, web=checkip.dynu.com/, web-skip='IP Address'    # Get ip from server.
server=api.dynu.com                                      # IP update server.
protocol=dyndns2                                         # Protocol for ddclient
login=LOGIN                                              # Your username.
password=PASWWORD                                        # Password or MD5/SHA256 of password.
DOMAIN                                                   # List one or more hostnames one on each line.
Quelques éléments y sont à modifier :
LOGIN
PASSWORD
```

Quelques éléments y sont à modifier :
- `LOGIN`
- `PASSWORD`
- et enfin, remplacez `DOMAIN` par votre nouveau domaine fraîchement créé

Une fois démarré, on peut consulter les logs du conteneur :

```bash
sudo docker logs -f ddclient
```

Et constater que la mise à jour est effective :

{{< image src="dynu3.webp" style="border-radius: 8px;" >}}

{{< image src="dynu4.webp" style="border-radius: 8px;" >}}
