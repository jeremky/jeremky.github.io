---
title: "Premiers pas avec Docker"
slug: premiers-pas-avec-docker
date: 2023-08-24T16:03:12Z
useRelativeCover: true
cover: cover.webp
tags:
    - docker
categories:
    - Tutos
toc: true
draft: false
---

*[Docker](https://fr.wikipedia.org/wiki/Docker_(logiciel)) est une plateforme permettant de lancer certaines applications dans des conteneurs logiciels lancée en 2013.*
*Docker est un outil qui peut empaqueter une application et ses dépendances dans un conteneur isolé, qui pourra être exécuté sur n'importe quel serveur. Il ne s'agit pas de virtualisation, mais de conteneurisation, une forme plus légère qui s'appuie sur certaines parties de la machine hôte pour son fonctionnement. Cette approche permet d'accroître la flexibilité et la portabilité d'exécution d'une application, laquelle va pouvoir tourner de façon fiable et prévisible sur une grande variété de machines hôtes, que ce soit sur la machine locale, un cloud privé ou public, une machine nue, etc.*

Docker offre donc les avantages de la virtualisation, mais sans les inconvénients (définition des ressources, installation de l'OS...). Vos applications s'exécuteront indépendamment du système de l'hôte, à partir du moment que Docker est installé.
Côté sécurité, vous pouvez définir quels sont les ports autorisés à sortir du conteneur, quels sont les fichiers partagés avec l'hôte...

Pour Installer Docker sous Debian, vous pouvez soit suivre la documentation d'installation [ici](https://docs.docker.com/engine/install/debian/), soit utiliser la version fournie directement dans les packages Debian. Sans rentrer dans les détails, la version fournie par Debian a une gestion des dépendances qui est plus en phase avec le fonctionnement de l'OS. Vu la version de Docker fournie dans la Debian 12, je préfère désormais utiliser cette version.

## Installation

L'installation se fait donc avec la commande suivante :

```bash
sudo apt-get update && sudo apt-get install docker.io docker-compose
```

docker-compose n'est pas indispensable, mais il sera nécessaire pour le déploiement d'applications utilisant plusieurs images. Nous verrons cela dans un prochain article dédié à docker-compose.

## Votre premier conteneur

Une fois installé, vous pouvez dès maintenant lancer votre 1er conteneur ! En test, je vous propose de lancer un conteneur Powershell (oui oui, Powershell sous Linux :smirk:) :

```bash
sudo docker run --name powershell -it --rm mcr.microsoft.com/powershell
```

Petite explication de la commande :

- `sudo docker run` : docker a besoin des droits root pour une question de sécurité.

- `--name` : le nom de votre conteneur (facultatif)

- `-it` : lance le conteneur en mode interactif. Le conteneur sera arrêté à la fermeture de l'application

- `--rm` : spécifie que le conteneur sera supprimé à l'arrêt de l'application

- et enfin, le nom de l'image docker

## Commandes utiles

Lister les conteneurs actuellement installés :

```bash
sudo docker container ls -a --format "table {{.Names}} \t {{.Status}} \t {{.Ports}} \t {{.Image}}"
```

Lister les volumes :

```bash
sudo docker volume ls
```

Lister les réseaux virtuels :

```bash
sudo docker network ls
```

Redémarrer un conteneur :

```bash
sudo docker restart
```

Mettre à jour les images téléchargées :

```bash
sudo docker images | grep -v ^REPO | grep -v none | sed 's/ \+/:/g' | cut -d: -f1,2 | xargs -L1 sudo docker pull
```

Purger les images et les volumes non utilisés (sans confirmation) :

```bash
sudo docker system prune -a --volumes -f
```

Consulter les logs pour un conteneur donné :

```bash
sudo docker logs -f <conteneur>
```

Rechercher une image docker :

```bash
sudo docker search <recherche>
```

## Conclusion

Vous l'aurez remarqué, certaines commandes peuvent être fastidieuses à utiliser...
C'est pourquoi je me suis fait un petit script bash, qui me facilite grandement la gestion de Docker au quotidien.

Je mettrai à disposition ce script dans l'article sur docker-compose (les commandes d'installation et de suppression se basant sur celui-ci).
