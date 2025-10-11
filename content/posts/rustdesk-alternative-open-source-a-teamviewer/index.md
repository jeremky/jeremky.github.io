---
title: "RustDesk : alternative open source à TeamViewer"
slug: rustdesk-alternative-open-source-a-teamviewer
date: 2025-07-06T16:12:32.707Z
useRelativeCover: true
cover: cover.webp
tags:
  - admin
  - docker
categories:
  - Tutos
toc: true
draft: false
---

Si comme moi, vous étiez à la recherche d'une alternative libre à TeamViewer,
je vous propose [**RustDesk**](https://rustdesk.com/fr/) !

RustDesk est une application de prise en main à distance, chiffrée de bout en bout,
avec un serveur qu'il est possible d'héberger. Elle fonctionne aussi bien en LAN
qu’en accès externe via Internet.

Ses points forts :

- Open source et gratuit
- Fonctionne sans configuration réseau complexe (NAT, etc.)
- Serveur d’identification et de relais en auto hébergement
- Application disponible sur Windows, Linux, macOS, Android, iOS

## Pourquoi l’auto-héberger ?

Héberger vous-même les serveurs `hbbs` (serveur public) et `hbbr`
(serveur de relais) permet :

- de garantir que vos connexions ne passent par aucun tiers
- de supprimer toute dépendance à l’infrastructure de RustDesk
- d’intégrer RustDesk dans votre écosystème existant (reverse proxy, DNS, etc.)

## Installation

Pour l'installer, je ne vais pas changer de méthode... Un petit fichier
`docker-compose.yml` :

```yml
services:
  hbbs:
    image: docker.io/rustdesk/rustdesk-server:latest
    container_name: rustdesk
    hostname: hbbs
    command: hbbs
    env_file: rustdesk.env
    ports:
      - 21115:21115
      - 21116:21116/tcp
      - 21116:21116/udp
    volumes:
      - ./files:/root
    depends_on:
      - hbbr
    restart: always

  hbbr:
    image: docker.io/rustdesk/rustdesk-server:latest
    container_name: rustdesk-relay
    hostname: hbbr
    command: hbbr
    ports:
      - 21117:21117
    volumes:
      - ./files:/root
    restart: always
```

Et son fichier `rustdesk.env` associé :

```txt
ALWAYS_USE_RELAY=N
```

Si cela est possible, RustDesk effectuera une connexion peer to peer entre les
2 machines pour de meilleures performances. Mais vous pouvez forcer l'utilisation
du serveur de relais.

### Firewall

Dans le cas où vous utilisez un firewall, pensez à ouvrir les ports en conséquence.
Certains ne nécessitent que du TCP, et un nécessite à la fois du TCP et de l'UDP.
Regardez directement le fichier `docker-compose.yml` pour avoir les informations.

Si comme moi vous utilisez [ufw](https://fr.wikipedia.org/wiki/Uncomplicated_Firewall),
voici les commandes à passer pour l'ajout des ports :

```bash
sudo ufw allow 21115/tcp
sudo ufw allow 21116
sudo ufw allow 21117/tcp
```

## Configuration côté client

Dans l’appli RustDesk (sur desktop ou mobile), il suffit d’indiquer les éléments
suivants dans les paramètres, dans Serveur ID/relais :

- Serveur ID : l'IP ou le nom DNS de votre serveur
- Serveur relais : même chose
- Serveur API : laissez-le à vide
- Key : Clé publique générée par RustDesk (fichier `id_ed25519.pub`
présent dans le volume)

{{< image src="settings.webp" style="border-radius: 8px;" >}}

Et c’est tout ! Les connexions ne passent plus par un serveur tiers. A noter que
tous les appareils que vous voulez faire communiquer doivent passer par ce même serveur.

## Conclusion

RustDesk est une excellente alternative à TeamViewer, qui m'a posé quelques soucis
dernièrement (une histoire de licence...). Le fonctionnement est sensiblement le
même. Et vous n'êtes pas obligé d'héberger un serveur pour l'utiliser. Notez toutefois
que vous passerez donc par leurs serveurs. Mais ce n'est finalement pas pire que
d'utiliser TeamViewer... :blush:
