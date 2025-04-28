---
title: "Podman : passer en rootless"
slug: podman-passer-en-rootless
date: 2025-04-28T18:52:49.994Z
useRelativeCover: true
cover: cover.webp
tags:
  - podman
categories:
  - Tutos
  - News
toc: true
draft: true
---

Il y a quelques mois, j'évoquais dans [cet article](/posts/migration-de-docker-vers-podman/) que j'avais décidé de migrer de Docker vers Podman. Et même si la force de Podman est de fonctionner sans les droits root (même si Docker a plus ou moins fait le nécessaire depuis), j'étais resté en mode rootfull, pour que la transition soit la plus douce possible. C'est désormais chose faite, et je vais exposer ici toutes les implications d'un passage au mode rootless.

## Avantages

Tout d'abord, j'aimerais rappeler les avantages d'utiliser Podman en rootless :

- Sécurité renforcée : Les conteneurs ne peuvent pas compromettre tout le système puisque l’utilisateur n’a pas les droits root. Même en cas d’évasion du conteneur, l’attaquant n’aurait accès qu’aux ressources de l’utilisateur courant 

- Moins de dépendances système : Pas besoin de démon système (comme dockerd) tournant en root. Chaque utilisateur peut lancer ses conteneurs de façon totalement autonome 

- Multi-utilisateurs : Chaque utilisateur peut gérer ses propres conteneurs et images sans interférer avec les autres 

- Conformité facilitée : Dans certains environnements (notamment professionnels), limiter les processus root est un prérequis de sécurité 

## Inconvénients

Mais évidemment, cela n'est pas sans conséquence :

- Le support du réseau est plus limité. Par exemple, sans privilèges supplémentaires, il est plus compliqué d’ouvrir des ports <1024. Ceci est toutefois configurable (nous allons voir cela plus loin)

- Certaines configurations réseau avancées (bridge personnalisé, VPN) sont plus complexes à mettre en place

- overlayfs, utilisé pour gérer les volumes et mutualiser les images, reste utilisé en rootless, mais avec des limitations. Sur certains systèmes de fichiers non compatibles avec le “unprivileged overlay”, Podman rootless peut tomber sur des erreurs, ou devoir utiliser des mécanismes moins performants. De plus, le mode rootless limite parfois l’efficacité de la mutualisation des couches, ce qui peut légèrement augmenter l’espace disque utilisé

## Préparation

Si, malgré ces avertissements, vous souhaitez tout de même vous lancer, voici les configurations à effectuer.

### Systemd

Afin que Podman démarre vos conteneurs au démarrage de votre serveur, vous devez activer le service systemd `podman-restart` :

```bash
systemctl enable --user --now podman-restart.service
```
> A noter que `restart: always` doit être spécifié

Autre service très utile, si vous avez besoin de Podman en mode socket, par exemple si certains de vos conteneurs doivent consulter ou contrôler d'autres conteneurs (comme [Portainer](/posts/portainer-administrer-vos-conteneurs-via-une-interface-web/) ou [Flame](/posts/flame-un-dashboard-leger-et-efficace/)) :

```bash
systemctl enable --user --now podman.socket
```

### Session

Par défaut, vos utilisateurs ne peuvent démarrer un service que si une session est démarrée (session ssh, gdm, etc...). Pour corriger ce comportement, vous devez autoriser votre utilisateur à lancer des services persistants :

```bash
sudo loginctl enable-linger <user>
```

### Réseau

Si vous utilisez des ports inférieurs à 1024, il faut indiquer à votre système à partir de quel port vous pouvez passer en `unprivileged`. Par exemple, avec le port 80 : 

```bash
sudo sysctl net.ipv4.ip_unprivileged_port_start=80
```

Et pour que cela soit pris en compte à chaque reboot, exécutez la commande suivante pour créer un fichier avec l'instruction ci-dessus :

```bash
echo "net.ipv4.ip_unprivileged_port_start=80" | sudo tee /etc/sysctl.d/10-podman.conf
```

### UFW

Le comportement réseau de Podman est différente en rootless. Dans [l'article précédent](/posts/migration-de-docker-vers-podman/#param%c3%a9trage-de-ufw), on autorisait tout le réseau de Podman. Désormais, il faudra ouvrir chaque port manuellement :

```bash
sudo ufw allow http
sudo ufw allow https
```

## Migration

Maintenant que tout est prêt, vous devrez recréer vos conteneurs, images, volumes et réseaux sous votre utilisateur non-root. Je vous laisse consulter les autres articles au sujet de [Docker](/posts/premiers-pas-avec-docker/) s'il vous manque certaines commandes. 

A noter que vos données ne sont pas perdues. Vous pouvez très bien changer les droits de vos volumes partagés par ceux de votre utilisateur. Les différents articles sur ce site proposaient de placer ces volumes dans `/opt`. Je vous conseille d'y créer un dossier `containers` avec les droits de votre utilisateur : 

```bash
sudo chown -R $USER:$USER /opt/containers
```

L'autre solution, serait de déplacer les données dans un répertoire de votre dossier `$USER`.

En parlant des données, vérifiez bien que si `/home` est une partition dédiée, qu'elle dispose de suffisamment de place pour les données de Podman (les données seront stockées dans `~/.local/share/containers` par défaut)

## jdocker.sh

Le script [jdocker.sh](https://github.com/jeremky/jdocker) a été grandement modifié afin de pouvoir fonctionner en rootless. La page Github documente les éléments à modifier avant utilisation.

Pour récupérer la dernière version : 

```bash
git clone https://github.com/jeremky/jdocker
```

## Conclusion

Passer Podman en rootless n’est pas si compliqué, mais demande quelques ajustements. La sécurité accrue et la flexibilité obtenues valent largement ces efforts, malgré une légère augmentation de l’espace disque utilisé.