---
title: Migration de Docker vers Podman
date: 2024-09-26T17:43:20+02:00
useRelativeCover: true
cover: cover.webp
tags:
  - podman
categories:
  - Tutos
toc: true
draft: false
---

[Docker](https://www.docker.com/), ce logiciel incroyable dont je vante les mérites depuis quelques années maintenant, possède une version Windows, [Docker Desktop](https://www.docker.com/), qui est désormais payante pour une utilisation en entreprise. Certaines rumeurs évoquent la possibilité que Docker finisse par être payant sur l'intégralité de leur produit. Il se peut que cela n'arrive jamais, mais dans le doute, il m'a été nécessaire d'envisager des alternatives. Conseillé par mes collègues, je me suis donc intéressé à l'application suivante : [Podman](https://podman.io/).

D'après Wikipedia : 

> *Podman est un logiciel libre permettant de lancer des applications dans des conteneurs logiciels. Il s’agit d’une alternative à Docker, qui permet de lancer les commandes sans les permissions root. À l’inverse de Docker, Podman n’intègre pas de daemon nécessaire à son fonctionnement.*

## Ca change quoi ?

Les changements entre les 2 solutions sont minimes. En réalité, Docker et Podman se basent sur certaines applications de plus bas niveau. Tout d'abord, [seccomp](https://fr.wikipedia.org/wiki/Seccomp), pour gérer le lien avec le noyau Linux, et [runc](https://github.com/opencontainers/runc), pour la création et l'exécution des conteneurs. Docker et Podman partagent donc globalement le même fonctionnement.

La force de Podman, se situe surtout dans sa capacité à pouvoir fonctionner en mode rootless, bien plus logique sur un poste de travail. La migration présentée dans cet article restera toutefois avec une utilisation en tant que `root`, afin d'être la plus transparente possible.

## Préparation de la migration

Tout d'abord, il est nécessaire de supprimer tous les conteneurs installés par Docker. Ensuite, il faut supprimer les packages et les dépendances. Si vous avez suivi mes tutos, cela se fait via la commande suivante :

```bash
sudo apt remove docker.io docker-compose && sudo apt autoremove
```

Maintenant, on peut passer à l'installation de Podman : 

```bash
sudo apt install podman podman-compose
```

### Alias

Si vous avez l'habitude d'utiliser la commande `docker`, vous pouvez ajouter des liens symboliques pour qu'ils pointent vers podman :

```bash
sudo ln -s /usr/bin/podman /usr/bin/docker
sudo ln -s /usr/bin/podman-compose /usr/bin/docker-compose
```

## Ajout du registry Docker

Afin de pouvoir rechercher des images sur le [Docker Hub](https://hub.docker.com/) à partir de la commande `podman search`, il faut ajouter une configuration à Podman.

Pour cela, modifiez la ligne suivante dans le fichier `/etc/containers/registries.conf` :

```txt
# unqualified-search-registries = ["exemple.com"]
```
Et remplacez là par :

```txt
unqualified-search-registries = ["docker.io"]
```

## Paramétrage de UFW

Si vous utilisez UFW comme Firewall, vous avez dû remarquer qu'aucune configuration n'est nécessaire pour Docker. Avec Podman, quelques opérations supplémentaires sont à effectuer pour permettre l'accès à vos conteneurs. 

Tout d'abord, il faut autoriser les redirections : 

```bash
sudo ufw default allow FORWARD
```

Ensuite, si vos conteneurs communiquent entre eux par leur nom (utilisé avec le [reverse proxy](/posts/reverse-proxy-nginx/) par exemple), vous devez autoriser la communication sur le réseau de podman : 

```bash
sudo ufw allow in on podman1
```

> Le script [aptinstall.sh](https://github.com/jeremky/aptinstall.sh) a été mis à jour en conséquence.

## jdocker.sh

Ce script avait été créé pour faciliter l'utilisation de Docker. Ce dernier a été transformé pour fonctionner maintenant avec Docker et Podman. La plupart des commandes sont identiques. Vous y trouverez également des exemples de fichiers `compose.yml` adaptés à Podman.

Pour récupérer la nouvelle version, [c'est ici](https://github.com/jeremky/jdocker.sh).

## Conclusion

Podman a été conçu en gardant l'idée de nous faciliter la migration depuis Docker. Il arrive cependant que quelques particularités soient dissimulées ici ou là. Je tâcherai de mettre à jour les fichiers de configurations docker-compose.yml présents dans les articles de ce site en fonction.

Pour différencier les articles à jour, vous n'aurez qu'à vérifier la présence du tag [#podman](/tags/podman/) sous le titre de chaque article. La configuration sera alors commune aux 2 applications. 

Dans le cas où vous changerez de solution, je vous souhaite une bonne migration !
