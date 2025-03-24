---
title: "podman-docker : une application pour faciliter la transition"
date: 2025-01-19T18:24:37.670Z
cover: /img/posts/podman-docker-application-faciliter-transition/cover.webp
tags:
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

Comme évoqué dans un [précédent article](https://www.jeremky.fr/posts/migration-de-docker-vers-podman/), j'ai pris la décision de migrer de Docker vers Podman pour la gestion de mes conteneurs.

Pour rappel, Podman a l'avantage de pouvoir fonctionner sans daemon central, ce qui améliore la sécurité du système. Cependant, même si un effort énorme est fourni pour faciliter la transition d'un service à l'autre, il subsiste [plusieurs inconvénients](/posts/reecriture-des-articles-docker/), notamment dans l’utilisation de `podman-compose` avec certains paramètres.

La version fournie dans les paquets Debian est assez ancienne. Et même s'il est possible de passer sur une version plus récente avec les backports de Debian, il restait quelques éléments qui posaient problème.

Certaines applications ne gèrent pas correctement Podman. C'est le cas de [lazydocker](https://github.com/jesseduffield/lazydocker) par exemple, qui ne trouve pas le socket, à moins de recréer un lien symbolique à chaque redémarrage du serveur.

Mais je me suis rendu compte récemment que j'étais passé à côté d'une application permettant de régler ces différents problèmes : `podman-docker`.

Disponible sur la plupart des distributions, ce package permet d'utiliser les commandes `docker` et `docker-compose` avec Podman. Il s'occupe également de créer les liens symboliques vers les différents fichiers de Podman.

Autrement dit, vous ne ferez aucune différence entre l'utilisation de Docker et de Podman.

## Installation

Avant de procéder à l'installation de l'application, je vous recommande de désinstaller `podman-compose` :

```bash
sudo apt remove podman-compose
```

On peut ensuite passer à l'installation de podman-docker :

```bash
sudo apt install podman-docker
```

Lorsque vous utiliserez les commandes de Docker, un message apparaîtra vous indiquant que c'est une émulation des commandes vers Podman. Si vous voulez supprimer le message, créez le fichier comme spécifié : 

```bash
sudo touch /etc/containers/nodocker
```

## Utilisation

A l'utilisation de `docker-compose`, tout est transparent. Il est quand même préférable de redéployer vos conteneurs après avoir changé d'application afin de redéfinir les bons labels. Mais je n'ai constaté aucun problème de communication entre `docker-compose` et `podman`.

Les fichiers `compose.yml` présentés sur ce site sont donc 100% compatibles avec les 2 solutions sans la moindre modification à effectuer (même au niveau du socket).

### jdocker.sh

Le script que je propose sur ce site pour faciliter l'utilisation de Docker a été revu en ce sens. Désormais, au 1er lancement, s'il ne trouve ni Docker, ni Podman, il va procéder à l'installation de Podman avec `podman-docker` (et donc `docker-compose`).

A noter que j'en ai profité pour apporter pas mal d'améliorations au script : 

- Mise en place de l'autocomplétion : les commandes de base ainsi que le nom des conteneurs vous sont proposés en utilisant la touche `TAB`

- Mise en place des droits sudo en `NOPASSWD` : vous pouvez utiliser `docker`, `podman` et le script `jdocker.sh` sans avoir à saisir votre mot de passe. `lazydocker` a également été ajouté.

- Le script vérifiera quand même quelle solution est installée et s'adaptera en conséquence. Cela le rend donc compatible avec Docker et Podman présents sur les dépôts Debian / Ubuntu, mais également avec la version Docker CE (qui dispose de la commande `compose` intégrée).

Le script est récupérable [sur github](https://github.com/jeremky/jdocker). Si vous disposez de la commande `git`, vous pouvez le récupérer directement via la commande suivante : 

```bash
git clone https://github.com/jeremky/jdocker.git
```

## Conclusion

Il arrivait souvent de rencontrer certains bugs avec l'utilisation de `podman-compose`. Le mode `host` n'était par exemple pas compatible avec la version présente sur les dépôts Debian. Et même si celle des backports corrigeait le problème, cela nécessitait des étapes supplémentaires avant de pouvoir utiliser correctement Podman.

`podman-docker` permet donc de profiter du meilleur des 2 applications : un gestionnaire de conteneurs plus sécurisé avec un gestionnaire de fichiers `compose` plus abouti. Ubuntu dispose toujours de ce paquet dans ses dépôts, cela assure donc qu'il sera toujours présent dans Debian 13. 

A l'avenir, il est possible que je réadapte `jdocker.sh` si jamais les choses avancent chez Podman. Mais pour le moment, je pense que cette combinaison est la meilleure solution.
