---
title: "Diun : être notifié des nouvelles images Docker"
date: 2024-12-02T19:09:00.558Z
cover: /img/posts/diun-etre-notifie-des-nouvelles-images-docker/cover.webp
tags:
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

D'après leur site, [Diun](https://crazymax.dev/diun/), pour *Docker Image Update Notifier*, est une application qui permet de recevoir des notifications lorsqu’une image Docker est mise à jour sur un registre. 

Contrairement à [Watchtower](/posts/watchtower-un-conteneur-pour-les-gouverner-tous/), Diun ne permet pas d'effectuer de mise à jour automatique, seulement de notifier. Cela a toutefois des avantages : 
- Le montage avec Docker est en Read Only. Cela assure donc un meilleur niveau de sécurité
- Vous gardez le contrôle sur le moment où vous voulez mettre à jour, en faisant des tests au préalable si nécessaire
- Diun est compatible avec [Podman](/posts/migration-de-docker-vers-podman/), contrairement à Watchtower

## Installation

On commence par le fichier `docker-compose.yml` :

```yml
services:
  diun:
    image: docker.io/crazymax/diun:latest
    container_name: diun
    hostname: diun
    env_file: diun.env
    volumes:
      - data:/data
      - /var/run/docker.sock:/var/run/docker.sock:ro
    healthcheck:
      test: ["CMD", "pgrep", "diun"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
    restart: always

volumes:
  data:
```

> Si vous utilisez Podman, il remplacez le volume par `/var/run/podman/podman.sock:/var/run/docker.sock:ro` 

Et son fichier `diun.env` :

```txt
TZ=Europe/Paris

DIUN_WATCH_WORKERS=20
DIUN_WATCH_SCHEDULE=0 */2 * * *
DIUN_WATCH_JITTER=30s
DIUN_PROVIDERS_DOCKER=true
DIUN_PROVIDERS_DOCKER_WATCHBYDEFAULT=true
```

Cette configuration permet d'effectuer une vérification toutes les 2 heures.

Par défaut, il est normalement nécessaire de spécifier pour chaque conteneur un label pour lui indiquer que l'on souhaite l'inclure aux vérifications. Il est possible d'automatiquement les intégrer avec la variable `DIUN_PROVIDERS_DOCKER_WATCHBYDEFAULT`. A l'inverse, pour exclure une conteneur, il est nécessaire d'y placer le label suivant : 

```yml
labels:
      - diun.enable=false
```

## Notification

Dans le fichier `diun.env`, vous pouvez lui spécifier des éléments en fonction de la façon dont vous voulez être notifié. Un exemple avec une notification par e-mail :

```txt
DIUN_NOTIF_MAIL_HOST=host
DIUN_NOTIF_MAIL_PORT=587
DIUN_NOTIF_MAIL_SSL=false
DIUN_NOTIF_MAIL_INSECURESKIPVERIFY=false
DIUN_NOTIF_MAIL_USERNAME=username
DIUN_NOTIF_MAIL_PASSWORD=password
DIUN_NOTIF_MAIL_FROM=emmeteur@mail.com
DIUN_NOTIF_MAIL_TO=destinataire1@mail.com,destinataire2@mail.com
```

Lorsqu'une nouvelle version d'image sera détectée, vous recevrez un mail sous cette forme : 

{{< image src="/img/posts/diun-etre-notifie-des-nouvelles-images-docker/mail.webp" style="border-radius: 8px;" >}}

Mais Diun permet de vous notifier via d'autres canaux : Discord, Slack, Teams... Je vous laisse aller voir en exemple le cas de Discord sur [cette page](https://crazymax.dev/diun/notif/discord/).

## Conclusion

Dans le cas où vous utilisez Watchtower ou le gestionnaire de mise à jour intégré à Podman (via [mon script](/posts/migration-de-docker-vers-podman/#jdockersh) par exemple), Diun n'a pas vraiment d'intérêt. Mais si vous utilisez [Portainer](/posts/portainer-administrer-vos-conteneurs-via-une-interface-web/) ou [Dockge](https://github.com/louislam/dockge) avec Podman, Diun est une excellente solution pour être informé des dernières versions d'image afin de rester à jour.

Si vous avez des questions sur ces sujets, vous pouvez me contacter par [e-mail](mailto:contact@jeremky.fr).