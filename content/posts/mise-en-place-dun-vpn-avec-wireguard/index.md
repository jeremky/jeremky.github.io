---
title: Mise en place d'un VPN avec Wireguard
slug: mise-en-place-dun-vpn-avec-wireguard
date: 2024-06-23T17:26:52Z
useRelativeCover: true
cover: cover.webp
tags:
  - reseau
  - docker
categories:
  - Tutos
toc: true
draft: false
---

Je ne vous présente pas ce qu'est un VPN, [Wikipedia](https://fr.wikipedia.org/wiki/Réseau_privé_virtuel)
fait ça très bien. Il existe plusieurs solutions pour héberger un VPN chez soi,
le plus connu étant OpenVPN. Mais un petit nouveau a fait son apparition depuis
quelques années. Il s'agit de [Wireguard](https://fr.wikipedia.org/wiki/WireGuard).
Ce dernier offre des performances dingues, que ce soit au niveau de la consommation
des ressources ou des capacités de transfert.

## Installation du serveur

Encore et toujours, je vous mets à disposition les fichiers compose que j'utilise.
L'image utilisée est fournie par [Linuxserver.io](https://www.linuxserver.io/).

Le fichier `docker-compose.yml` :

```yml
services:
  wireguard:
    image: lscr.io/linuxserver/wireguard:latest
    container_name: wireguard
    hostname: wireguard
    env_file: wireguard.env
    cap_add:
      - NET_ADMIN
    volumes:
      - /opt/containers/wireguard:/config
      - /lib/modules:/lib/modules
    ports:
      - 51820:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: always
```

Son fichier `wireguard.env` :

```bash
PUID=1000
PGID=1000
TZ=Europe/Paris
SERVERURL=foo.bar.com
SERVERPORT=51820
PEERS=client1,client2
PEERDNS=1.1.1.2,1.0.0.2
INTERNAL_SUBNET=10.13.13.0
ALLOWEDIPS=0.0.0.0/0
```

Dans ce fichier, vous avez quelques éléments à modifier :

- La variable `SERVERURL` à remplacer par votre nom de domaine
- La variable `PEERS`, qui contient la liste de vos clients VPN séparés par une virgule
- La variable `PEERDNS`, où vous allez définir les serveurs DNS à utiliser
(Cloudflare dans notre exemple)

## Configuration du client

Pour l'installation du client, vous pouvez vous rendre sur [cette page](https://www.wireguard.com/install/).
Le client est disponible pour tous les systèmes d'exploitation. Une fois installé,
vous pouvez ajouter la configuration soit manuellement, soit en effectuant un scan
d'un QR code depuis vos appareils mobile. Il peut s'afficher directement dans
votre terminal :

```bash
docker exec -it wireguard /app/show-peer client1
```

{{< image src="peer.webp" style="border-radius: 8px;" >}}

Je vous conseille d'ajouter un alias dans votre fichier `.bash_aliases`
pour plus de confort :

```bash
alias peer='docker exec -it wireguard /app/show-peer $1'
```

Si toutefois vous devez ajouter les infos manuellement, le fichier de configuration
se trouve sur votre hôte dans un sous dossier de `/opt/containers/wireguard`.
Dans notre exemple : `/opt/containers/wireguard/peer_client1/peer_client1.conf`
Une fois la configuration importée, vous pouvez activer votre VPN !

## Firewall UFW

Si vous souhaitez accéder à vos applications sur le même serveur où se trouve
Wireguard et que vous avez ufw installé, vous constaterez que vos applications
ne sont pas accessibles... Il est donc nécessaire, sur le host, d'ajouter les
ports à autoriser pour votre conteneur Wireguard. Par exemple, pour accéder à
votre proxy web :

```bash
sudo ufw allow https
```

## Port NAT

Enfin, pour pouvoir accéder à votre VPN depuis Internet, vous devez ajouter une
ouverture de port NAT sur votre box. Dans le cas de Wireguard, il faut ouvrir le
port UDP 51820.
