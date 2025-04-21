---
title: Mise en place d'un service de test de débit
slug: mise-en-place-dun-service-de-test-de-debit
date: 2024-05-29T17:18:37Z
useRelativeCover: true
cover: cover.webp
tags:
  - reseau
  - docker
categories:
  - Tutos
toc: false
draft: false
---

Il arrive régulièrement d'être amené à devoir tester son débit Internet. Malheureusement, on passe généralement par une application ou un site web, bourré de pubs et de télémétrie dans tous les sens. L'idée est donc de vous proposer ce simple service pour tester votre débit. Pas de fioriture, on va à l'essentiel. Son nom : [Librespeed](https://github.com/librespeed/speedtest?tab=readme-ov-file).

Le service n'est plus accessible sur ce serveur. L'adresse officielle : https://librespeed.org/

## Son fonctionnement

Comme la plupart des services de test de débit, Librespeed va choisir pour vous le meilleur serveur distant en fonction de votre opérateur et de votre position géographique.

{{< image src="result.webp" style="border-radius: 8px;" >}}

Une fois le test effectué, il est possible de copier l'url du résultat si nécessaire.

## L'installation

Si vous voulez l'héberger chez vous, c'est comme à chaque fois :grin:

Un fichier de configuration `compose.yml` :

```yml
services:
  librespeed:
    image: lscr.io/linuxserver/librespeed:latest
    container_name: librespeed
    hostname: librespeed
    env_file: librespeed.env
    networks:
      - nginx_proxy
    volumes:
      - data:/config
    restart: always

networks:
  nginx_proxy:
    external: true
    
volumes:
  data:
```

Et son fichier `librespeed.env` :

```bash
PUID=1000
PGID=1000
TZ=Europe/Paris
```

Bons tests !
