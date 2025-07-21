---
title: "Webtop : Linux via son navigateur Internet"
slug: webtop-linux-via-navigateur-internet
date: 2025-03-06T16:21:02.059Z
useRelativeCover: true
cover: cover.webp
tags:
  - docker
categories:
  - Tutos
toc: true
draft: false
---

La flexibilité de Docker n'est plus à démontrer. Il m'est arrivé plusieurs fois d'être surpris par les possibilités de cet outil et par la créativité de certains développeurs dans l'intégration d'applications.

Mais si j'avais pour rôle de donner un prix pour l'image du moment, je le dédierais à [Webtop](https://docs.linuxserver.io/images/docker-webtop/).

Webtop est une image fournie par l'équipe [Linuxserver.io](https://www.linuxserver.io/) qui a pour but de donner l'accès à un OS Linux complet, et ce via un serveur VNC accessible directement depuis son navigateur Web.

L'image permet d'installer automatiquement des logiciels sans avoir à modifier l'image, permet de placer le serveur web derrière un proxy, dispose d'un gestionnaire d'applications persistantes... Une pépite.

## Installation

Voici les fichiers nécessaires pour installer Webtop. Le fichier `docker-compose.yml` :

```yml
services:
  webtop:
    image: lscr.io/linuxserver/webtop:latest
    container_name: webtop
    hostname: webtop
    env_file: webtop.env
    cpus: 2
    mem_limit: 2G
    networks:
      - nginx_proxy
    volumes:
      - /opt/containers/containers/webtop:/config
    shm_size: "1gb"
    restart: always

networks:
  nginx_proxy:
    external: true
```

- Par défaut, Linuxserver a choisi Alpine Linux comme distribution avec l'environnement de bureau Xfce. Après avoir fait plusieurs tests, elle est de loin la plus stable et la plus légère. Je vous conseille de rester sur celle-ci
- J'ai limité le conteneur à 2 CPUs et 2 Go de RAM pour éviter de mauvaises surprises. A changer aux besoins
- `shm_size: "1gb"` est nécessaire pour éviter des plantages du navigateur Chromium intégré
- Pensez à ajouter les volumes à partager avec l'hôte pour y retrouver vos données

> Mon serveur ne prenant pas en charge l'accélération matérielle, je ne l'ai pas activé. Si besoin, vous trouverez les infos sur la [page de Webtop](https://docs.linuxserver.io/images/docker-webtop/)

Le fichier `webtop.env` :

```bash
PUID=1000
PGID=1000
TZ=Europe/Paris
TITLE=Webtop
LC_ALL=fr_FR.UTF-8
START_DOCKER=false
DISABLE_IPV6=true
DOCKER_MODS=linuxserver/mods:universal-package-install
INSTALL_PACKAGES=aspell|aspell-fr|colordiff|fd|font-jetbrains-mono-nerd|fzf|git|htop|ncdu|papirus-icon-theme|ripgrep|thunar-archive-plugin|tmux|vim|xarchiver|zip|zoxide
```

- la variable `START_DOCKER` permet de contrôler Docker via ce container. Il est désactivé dans cet exemple, car je n'en ai pas l'utilité : il est possible d'utiliser un terminal de ce conteneur comme rebond SSH vers votre serveur
- la variable `INSTALL_PACKAGES` permet de lui préciser quels packages vous voulez installer après le déploiement, peu importe la distribution choisie. J'ai donc ajouté quelques outils qui m'ont semblé pertinent selon mes besoins
- Là encore, j'ai laissé l'ID 1000, correspondant au 1er user de votre hôte. A changer selon vos besoins

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisés avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) propose un fichier sample de configuration, il vous suffit juste de modifier votre nom de domaine en conséquence :

```bash
sudo cp /opt/containers/nginx/nginx/proxy-confs/webtop.subdomain.conf.sample /opt/containers/nginx/nginx/proxy-confs/webtop.subdomain.conf
sudo sed -i "s,server_name webtop,server_name <votre_sous_domaine>,g" /opt/containers/nginx/nginx/proxy-confs/webtop.subdomain.conf
```

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

> Point important sur la sécurité : il est possible de protéger l'accès à Webtop par un simple mot de passe, mais je vous conseille fortement d'utiliser l'outil d'authentification [Authelia](/posts/authelia-serveur-dauthentification-open-source/), qui propose de la double authentification

## Configuration

Une fois votre conteneur déployé, vous allez vous retrouver avec un environnement Xfce par défaut... assez austère : 

{{< image src="default.webp" style="border-radius: 8px;" >}}

N'étant pas le plus sexy de base, je vous propose d'utiliser une configuration que je vous mets à disposition. Pour l'installer :

- Téléchargez le fichier suivant : [webtop.tar.gz](/files/webtop.tar.gz)
- Arrêtez votre conteneur, supprimez le répertoire `/opt/containers/webtop` (volume par défaut), et décompressez cette archive en remplacement de ce répertoire (utilisez `sudo`)
- Relancez votre conteneur, et profitez du changement :blush:

Les changements sont les suivants : 

- Personnalisation du thème : ajout des icônes "Papirus", du Thème "Arc", suppression des applets inutiles...
- Désactivation des icônes du bureau : le menu des applications est disponible de n'importe où via un clic droit, et la roulette permet de basculer entre les bureaux
- Masquage de certaines applications totalement inutiles
- Possibilité de lancer un terminal en plein écran via le raccourci `Ctrl + Entrée`
- Ajout de configurations pour htop, vim, tmux, ainsi que différents alias, dont `upgrade` adapté pour la distribution Alpine

### Chromium

Petit point sur le navigateur Chromium. Par défaut, il utilise l'accélération matérielle, ce qui le rend inutilisable sur Webtop, du moins sans ajouter la prise en charge matérielle par le conteneur. Pensez donc à aller le désactiver :

{{< image src="chromium.webp" style="border-radius: 8px;" >}}

## PRoot ?

Allez, tous ensemble : "HA HA HA"... Maintenant qu'on a bien rigolé sur ce nom étrange, on va pouvoir dire ce que c'est :smile:

[PRoot](https://github.com/linuxserver/proot-apps) est une solution créée par la team LinuxServer pour installer de manière isolée des applications sans privilèges élevés. Autrement dit : vous pouvez installer des applications indépendamment de l'image Docker, afin de retrouver votre environnement malgré un redéploiement de cette dernière.

Par exemple, pour installer FileZilla : 

```bash
proot-apps install filezilla
```

La liste des applications est disponible à [ce lien](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps) ("Click to expand"). Dans le lot, j'ai surtout utilisé un temps VSCodium pour modifier mes scripts (avant de repasser à Neovim...).

Vous pouvez également installer leur "store" d'applications. Il fonctionne, mais peut se montrer assez instable. A utiliser si vraiment les lignes de commande vous font peur :

```bash
proot-apps install gui
```

## Conclusion

Disposer d'un Linux accessible de n'importe où peut vraiment être pratique. Je m'en sers surtout pour me connecter à mon serveur OVH, que j'ai protégé en forçant une connexion par clé RSA. Combiné à Authelia, je peux donc y accéder via une double authentification, la clé étant sur ce Linux.

Mais vu les applications qui sont proposées par l'équipe, vous trouverez sûrement un autre truc sympa à faire avec ! :blush:
