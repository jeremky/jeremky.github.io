---
title: "Podman : passage en rootless"
slug: podman-passage-en-rootless
date: 2025-05-16T12:46:28.143Z
useRelativeCover: true
cover: cover.webp
tags:
  - podman
categories:
  - Tutos
  - News
toc: true
draft: false
---

Il y a quelques mois, j'évoquais dans [cet article](/posts/migration-de-docker-vers-podman/) ma décision de migrer de Docker vers Podman. Et même si la force de Podman est de fonctionner sans les droits root (même si Docker a plus ou moins fait le nécessaire depuis), j'étais resté en mode rootful, pour que la transition soit la plus douce possible. J’ai finalement franchi le pas, et je vais exposer ici toutes les implications d'un passage au mode rootless.

## Avantages

Tout d'abord, j'aimerais rappeler les avantages d'utiliser Podman en rootless :

- Sécurité renforcée : Les conteneurs ne peuvent pas compromettre tout le système puisque l’utilisateur n’a pas les droits root. Même en cas d’évasion du conteneur, l’attaquant n’aurait accès qu’aux ressources de l’utilisateur courant 

- Moins de dépendances système : pas besoin de démon système (comme dockerd) tournant en root. Chaque utilisateur peut lancer ses conteneurs de façon totalement autonome 

- Multi-utilisateurs : chaque utilisateur peut gérer ses propres conteneurs et images sans interférer avec les autres 

- Conformité facilitée : dans certains environnements (notamment professionnels), limiter les processus root est un prérequis de sécurité 

## Inconvénients

Mais évidemment, cela n'est pas sans conséquence :

- Le support du réseau est plus limité. Par exemple, sans privilèges supplémentaires, il est plus compliqué d’ouvrir des ports <1024. Ce comportement peut toutefois être contourné (nous allons voir cela plus loin)

- Certaines configurations réseau avancées (bridge personnalisé, VPN) sont plus complexes à mettre en place

- overlayfs, utilisé pour gérer les volumes et mutualiser les images, reste utilisé en rootless, mais avec des limitations. Sur certains systèmes de fichiers non compatibles avec le “unprivileged overlay”, Podman rootless peut tomber sur des erreurs, ou devoir utiliser des mécanismes moins performants. De plus, le mode rootless limite l’efficacité de la mutualisation des couches, ce qui peut légèrement augmenter l’espace disque utilisé

## Comparatif rootful vs rootless

| Critère                         | Mode rootful                                       | Mode rootless                                      |
|---------------------------------|----------------------------------------------------|----------------------------------------------------|
| Droits nécessaires              | Root requis                                        | Aucun droit root requis                            |
| Sécurité                        | Risque en cas d’évasion de conteneur               | Isolation renforcée par user namespaces            |
| Démarrage automatique           | Via systemd en root                                | Via `systemctl --user` et `loginctl enable-linger` |
| Réseau (ports < 1024)           | Autorisés par défaut                               | Nécessite une configuration système (`sysctl`)     |
| Isolation multi-utilisateur     | Non séparée par défaut                             | Chaque utilisateur a ses propres conteneurs/images |
| Gestion des volumes             | Simplicité d'accès                                 | Restrictions selon le FS (`unprivileged overlay`)  |
| Compatibilité applications      | Maximale                                           | Parfois limitée (ex : images attendent d’être root)|
| Accès au socket Docker/Podman   | Accessible en root                                 | Accessible via `podman.socket` en mode utilisateur |

## Préparation

Si, malgré ces avertissements, vous souhaitez tout de même vous lancer, voici les configurations à effectuer.

### Systemd

Afin que Podman démarre vos conteneurs au démarrage de votre serveur, vous devez activer le service systemd `podman-restart` :

```bash
systemctl enable --user --now podman-restart.service
```
> À noter que `restart: always` doit être spécifié dans votre fichier `docker-compose.yml`

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

Le comportement réseau de Podman est différent en rootless. Dans [l'article précédent](/posts/migration-de-docker-vers-podman/#param%c3%a9trage-de-ufw), on autorisait tout le réseau de Podman. Désormais, il faudra ouvrir chaque port individuellement :

```bash
sudo ufw allow http
sudo ufw allow https
```

### Users

Quelques explications au sujet des utilisateurs. Certaines images, notamment celles de Linuxserver.io, tentent de compenser la lacune du mode rootful en forçant l'utilisation d'un ID non root. 

Le mode rootless de Podman transforme l'ID de votre utilisateur en ID 0 dans le conteneur. La conséquence, c'est de se retrouver parfois avec des ID sur 6 chiffres (comme un “masque” appliqué via les user namespaces, mappant les UID visibles à l’intérieur du conteneur vers des UID non root sur l’hôte). Ce n’est pas bloquant, mais cela peut surprendre au début.

Vous pouvez d'ailleurs vérifier les ID utilisés en utilisant la commande suivante :

```bash
podman unshare
```

Cette commande ouvre un shell dans le namespace utilisateur de Podman, vous permettant d’examiner le mappage des UID/GID ou de manipuler certains fichiers comme si vous étiez dans le conteneur.

## Migration

Maintenant que tout est prêt, vous devrez recréer vos conteneurs, images, volumes et réseaux sous votre utilisateur non root. Je vous laisse consulter les autres articles au sujet de [Docker](/posts/premiers-pas-avec-docker/) s'il vous manque certaines commandes. 

A noter que vos données ne sont pas perdues. Vous pouvez très bien changer les droits de vos volumes partagés par ceux de votre utilisateur. Les différents articles sur ce site proposent généralement de placer ces volumes dans `/opt`. Je vous conseille d'y créer un dossier `containers` avec les droits de votre utilisateur : 

```bash
sudo chown -R $USER:$USER /opt/containers
```

L'autre solution serait de déplacer les données dans un répertoire de votre dossier `$USER`.

En parlant des données, vérifiez bien que si `/home` est une partition dédiée, qu'elle dispose de suffisamment de place pour les données de Podman (les données seront stockées dans `~/.local/share/containers` par défaut)

## jdocker.sh

Le script [jdocker.sh](https://github.com/jeremky/jdocker) a été grandement modifié afin de pouvoir fonctionner en rootless. [La page Github](https://github.com/jeremky/jdocker) documente les éléments à modifier avant utilisation.

Pour récupérer la dernière version : 

```bash
git clone https://github.com/jeremky/jdocker
```

## Modification des articles

Les articles sur ce site autour de l'installation d'applications conteneurisées avaient comme tags [#docker](/tags/docker/) et [#podman](/tags/podman/), la compatibilité ayant été assurée. N'ayant pas pu retester toutes les applications mentionnées en rootless, j'ai préféré retirer le tag [#podman](/tags/podman/) des différents articles. Ce tag ne servira donc uniquement que pour les spécificités de Podman. Cela ne signifie pas que les applications ne sont pas compatibles (je n'ai eu pour le moment aucun problème avec les applications que j'utilise encore), mais je préfère rester prudent. A vous de tester et d'adapter en fonction de vos besoins.

## Conclusion

Passer Podman en rootless n’est pas si compliqué, mais demande quelques ajustements. La sécurité accrue et la flexibilité obtenue valent largement ces efforts, malgré une légère augmentation de l’espace disque utilisé.
