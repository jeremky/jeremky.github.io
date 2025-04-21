---
title: La fin d'EmulatorJS
slug: la-fin-demulatorjs
date: 2024-05-26T17:17:57Z
useRelativeCover: true
cover: cover.webp
tags:
  - infos
  - jeux
categories:
  - News
toc: false
draft: false
---

EmulatorJS, c'est fini... J'ai pris la décision d'arrêter de mettre à disposition le service emu.jeremky.fr, et ceci pour différentes raisons que je détaille ci-dessous.

## Problèmes de compatibilité

Faire fonctionner un émulateur dans un navigateur Web, c'est techniquement une prouesse, pas de doute. Mais cela amène son lot de problèmes de compatibilité avec les navigateurs.

Certaines consoles (PlayStation, Nintendo 64, Saturn...) ne peuvent pas fonctionner sur certaines plateformes, à cause de la limitation en RAM. C'est le cas par exemple du navigateur Edge de la Xbox, qui est limité en mémoire par Microsoft. Et même sur les rares navigateurs compatibles, le rendu n’est pas toujours au rendez-vous.

A cela s'ajoute également des problèmes de craquement de son, mais aussi des latences au niveau de l'image, l'émulateur ne permettant pas un bon fonctionnement de la synchro entre le framerate du jeu et le rafraîchissement de l'écran, et ce malgré la synchro verticale activée.

## Manque de fonctionnalités

EmulatorJS est principalement basé sur RetroArch. Ce frontend est un monstre en terme de personnalisation. Malheureusement, beaucoup d'options ne sont pas disponibles dans la version embarquée d’EmulatorJS.

Il manque un bon nombre de shaders, notamment des shaders permettant d'ajouter du scanline, ou un rendu rétro, afin de diminuer la difficulté que l'on peut avoir à revoir les bons vieux pixels de l'époque :sweat_smile:

Côté interface, il devient vite fastidieux de vouloir passer d'un jeu à l'autre, le système démarrant chaque jeu dans une instance RetroArch séparée. Cela signifie un freeze de l'appli lorsqu'on l'arrête, suivi d'un retour arrière manuel sur la page (Là encore, sur Xbox, c'est galère).

La gestion des sauvegardes, n'est pas automatique. Même lorsque l'on a un compte sur EmulatorJS, l'envoi/réception des backups et des configs doit se faire manuellement. Cela m'a valu quelques surprises lorsque des backups étaient sur différents supports. Écraser des données de sauvegarde alors que je voulais récupérer des changements de config m'est arrivé plusieurs fois... :anguished:

Et puis il manque tout simplement certaines consoles, incompatibles avec ce système (Dreamcast, Gamecube, PSP...).

## Gestion des ROMs

Les problèmes cités plus haut m'ont obligé à peaufiner certains choix de ROMs. En effet, les problèmes de rafraîchissement apportaient des problèmes avec les ROMs européennes (50hz).

Autre élément fastidieux, l'émulateur qui a été retenu pour les bornes d'arcade. Dans EmulatorJS, seul MAME 2003 plus est disponible. Et encore, certains jeux d'un Full Romset sensé être 100% compatible ne fonctionnent pas. Et malheureusement, Final Burn Neo n'est pas présent, on se prive donc là encore d'une partie du catalogue arcade (Certains jeux CPS2 et CPS3 par exemple).

## Du coup, c'est quoi les alternatives ?

Le plus simple, c'est d'avoir une machine dédiée. Un Raspberry Pi, ou mieux encore, un ordi. Ensuite, le système, c'est selon s'il est possible de la dédier exclusivement à l'émulation ou non.

Sur un PC de quelques années, vous n'aurez aucun problème à faire tourner la Dreamcast, Gamecube, même quelques jeux Wii. Côté Arcade, y'a la Naomi, Atomiswave, Sega Model 3... Le tout souvent en HD. Et sur une machine plus récente, la PS2 devrait également fonctionner.

Pour le choix de l'OS, regardez d'abord [Recalbox](https://www.recalbox.com/fr/), c'est le plus accessible. J'avais une préférence pour [Lakka](https://www.lakka.tv/) avant, mais la dernière version de Recalbox fonctionne du tonnerre... En espérant que votre machine est compatible (j'ai quand même eu quelques mésaventures sur un mini PC récent). Il dispose d’une belle interface, d’options permettant par exemple de choisir pour vous le meilleur shader selon la console, et d’un bon système de récupération des jaquettes efficace. À noter qu’il est possible de se faire une clé bootable.

L'autre possibilité, c'est de faire tourner l'application [Retroarch](https://www.retroarch.com/?page=platforms) directement sur votre OS. Le nombre d'appareils compatibles est juste fou... Windows, Mac, Linux, Steam, certaines consoles (en bidouillant), Android et depuis peu... iOS (dont l'AppleTV, mon choix aujourd’hui).

Pour la récupération des ROMs, ne vous embêtez pas... Le site [archive.org](https://archive.org/) contient tout ce dont vous aurez besoin. Que ce soit un Full RomSet de FBNeo, ou même des jeux PSX en format CHD (moins lourds à stocker), tout s'y trouve. Privilégiez la récupération des ROMs US lorsque c'est possible pour les consoles antérieures à la Dreamcast pour ne pas être bridé à 50hz.

## Installer EmulatorJS chez soi

Si toutefois vous désirez vous installer une instance d’EmulatorJS, je vous laisse ici la configuration Docker que j'ai utilisé.

Le fichier `compose.yml` :

```yml
services:
  emulatorjs:
    image: lscr.io/linuxserver/emulatorjs:latest
    container_name: emulatorjs
    hostname: emulatorjs
    env_file: emulatorjs.env
    cpus: 2
    networks:
      - nginx_proxy
    volumes:
      - /opt/emulatorjs/config:/config
      - /opt/emulatorjs/data:/data
    restart: always

networks:
  nginx_proxy:
    external: true
```

Le fichier `emulatorjs.env` :

```env
PUID=1000
PGID=1000
TZ=Europe/Paris
SUBFOLDER=/backend/
DISABLE_IPFS=false
```

> Si vous n'avez pas l'intention d'ajouter des jeux par la suite, passez la variable `DISABLE_IPFS` à `true` pour économiser de la ressource

Pour le déploiement à l'aide de ces fichiers, vous devrez utiliser un reverse proxy. Vous aurez ce qu'il faut pour en mettre un en place sur [cette page](/posts/reverse-proxy-nginx/). Un fichier de configuration pour EmulatorJS est fourni dans l'image du proxy nginx.

Si vous voulez des précisions sur le fonctionnement de l'image Docker d'EmulatorJS, je vous redirige vers la documentation de [LinuxServer](https://docs.linuxserver.io/images/docker-emulatorjs/#docker-cli-click-here-for-more-info).
