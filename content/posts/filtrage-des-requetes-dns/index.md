---
title: Filtrage des requêtes DNS
slug: filtrage-des-requetes-dns
date: 2023-12-30T17:10:13Z
useRelativeCover: true
cover: cover.webp
tags:
  - reseau
categories:
  - Tutos
toc: true
draft: false
---

Utiliser un Adblock directement dans son navigateur rend la navigation plus agréable...
Mais on peut aller encore plus loin : bloquer les publicités directement au niveau
des requêtes DNS, non seulement dans le navigateur, mais également sur tout le
système d'exploitation. Il existe plusieurs solutions pour faire cela, mais je
vais en présenter deux : Adguard et NextDNS.

## Adguard DNS et Adguard Home

[Adguard](https://adguard.com/fr/welcome.html) existe sous la forme d'un bloqueur
de pubs traditionnel, mais propose également des solutions de blocage DNS.

La première, Adguard DNS, est la plus simple à mettre en place, puisque l'on peut
utiliser des serveurs DNS que Adguard nous met à disposition. Vous trouverez sur
[cette page](https://adguard-dns.io/fr/public-dns.html), les IP v4 et v6 de leurs
serveurs. Ils proposent plusieurs possibilités de filtrage : classique, non filtrant,
et avec une protection dite familiale.

{{< image src="adguard.webp" style="border-radius: 8px;" >}}

Le blocage fonctionne plutôt bien dans leur configuration. J'ai toutefois constaté
quelques baisses de performance comparé à d'autre fournisseurs DNS, et cette
configuration est limitée sur les appareils où vous pouvez manuellement changer
les adresses IP DNS.

Pour contourner ces problèmes, il y a une autre solution : Adguard Home

Ce logiciel vous permettra de mettre en place chez vous une solution de blocage
des pubs pour tout votre réseau local. Il fourni également un serveur DHCP afin
d'automatiser la configuration IP pour tous vos appareils (TV, consoles, smartphones...).

Cette solution peut s'installer facilement, un raspberry pi fait très bien le taff.
Ils proposent un script d'installation, et... Vous vous en doutez peut être :
une image Docker :smile:

Le fichier `docker-compose.yml` :

```yml
services:
  adguard:
    image: docker.io/adguard/adguardhome
    container_name: adguard
    hostname: adguard
    env_file: adguard.env
    volumes:
      - /opt/containers/adguard/work:/opt/adguardhome/work
      - /opt/containers/adguard/conf:/opt/adguardhome/conf
    network_mode: host
    restart: always
```

Et son fichier de configuration `adguard.env` :

```bash
TZ=Europe/Paris
```

Petite particularité par rapport à cette configuration : le mode réseau utilisé
par Docker est en mode *host*. Cela signifie que l'intégralité des ports sera
ouverte sur l'hôte, préférable pour s'assurer du bon fonctionnement du serveur DHCP.

Une fois votre image Docker déployée, vous pouvez accéder à l'interface d'administration
directement à l'adresse `http://<IP>:3000`.
La configuration étant intuitive, je vous laisse vous balader dans l'application,
dont l'interface est très propre et complète.

{{< image src="adguardhome.webp" style="border-radius: 8px;" >}}

Il subsiste toutefois un problème avec ce genre de configuration : cela ne s'applique
qu'à votre réseau local. Il reste la possibilité d'utiliser un VPN pour passer
par votre réseau domestique, mais cela alourdi pas mal les échanges réseau et donc
le temps de réponse de vos requêtes.

Nous allons résoudre ce problème en parlant de l'alternative de cet article : NextDNS

## NextDNS

{{< image src="nextdnssite.webp" style="border-radius: 8px;" >}}

NextDNS est à mon sens le meilleur compromis entre la personnalisation et la simplicité
d'utilisation. Ce service permet de profiter d'un blocage de publicités quelque
soit le réseau utilisé (Wifi, cellulaire). Ce service dispose d'une version gratuite
et payante, mais la version gratuite suffit déjà largement, la seule limitation
étant celle de 300 000 requêtes par mois. Si jamais ce n'est pas suffisant,
il est possible de combiner NextDNS avec Adguard Home, en spécifiant à NextDNS
de ne pas être actif sur des réseaux spécifiques.

Avant de créer un compte chez eux, il est possible de tester leur service une semaine.
Un petit tour de leur interface :

{{< image src="confidentialite.webp" style="border-radius: 8px;" >}}
***
{{< image src="securite.webp" style="border-radius: 8px;" >}}
***
{{< image src="statistiques.webp" style="border-radius: 8px;" >}}

A noter que vous pouvez conserver l'historique ou non des url appelées, choisir
la rétention, et surtout, le lieu où sont conservées les logs
(US, Europe, ou la Suisse)

Dans le 1er onglet, Installation, vous aurez toutes les méthodes disponibles pour
mettre en place la solution, en installant un logiciel à eux ou en modifiant
vos paramètre (Windows, Android, MacOS, iOS...)

Et pour finir, ils proposent un mode "Ultra-Low Latency Network", qui améliorent
pas mal les temps de réponse (meilleurs qu'avec votre fournisseur d'accès Internet).
