---
title: "Migration vers Podman"
slug: migration-vers-podman
contextMenu: true
weight: 4
toc: true
tags:
  - docker
draft: false
lastmod: 2026-05-17
---

_[Podman](https://fr.wikipedia.org/wiki/Podman) est une alternative à Docker, qui permet de lancer les commandes sans les permissions root. À l’inverse de Docker, Podman n’intègre pas de daemon nécessaire à son fonctionnement._

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
