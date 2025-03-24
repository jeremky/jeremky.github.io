---
title: "Wireguard Easy : Simplifiez la gestion de Wireguard"
date: 2024-11-17T15:32:00.326Z
cover: /img/posts/wireguard-easy-simplifiez-la-gestion-de-wireguard/cover.webp
tags:
  - reseau
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

Comme vu dans [cet article](/posts/mise-en-place-dun-vpn-avec-wireguard/), [Wireguard](https://www.wireguard.com/) est un VPN très performant et facile à mettre en place, mais son administration via des fichiers de configuration peut paraître assez compliquée. C'est là qu'intervient Wiregard Easy.

[Wireguard Easy](https://github.com/wg-easy/wg-easy) est une interface graphique légère et open source conçue pour simplifier la gestion de WireGuard. Elle permet de gérer facilement les pairs (clients), de visualiser l'état des connexions, ainsi que la volumétrie de données transitant en temps réel. Il est également possible d'exporter facilement la configuration en cas de réinstallation ultérieure.

## Installation

Comme d'habitude, on commence par un fichier `docker-compose.yml` :

```yml
services:
  wireguard:
    image: ghcr.io/wg-easy/wg-easy
    container_name: wireguard
    hostname: wireguard
    env_file: wireguard.env
    networks:
      - nginx_proxy
    volumes:
      - /opt/wireguard:/etc/wireguard
    ports:
      - 51820:51820/udp
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
      - NET_RAW
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
    restart: always

networks:
  nginx_proxy:
    external: true
```

> Le paramètre `NET-RAW` dans la partie `cap_add` n'est a utiliser que si vous utilisez Podman à la place de Docker.

Le fichier `wireguard.env` associé :

```txt
LANG=fr
WG_HOST=vpn.domaine.fr
WG_DEFAULT_DNS=1.1.1.2,1.0.0.2
UI_TRAFFIC_STATS=true
```

D'autres options de paramétrage sont disponibles. Vous pouvez vous rendre sur [cette page](https://github.com/wg-easy/wg-easy) pour les consulter.

A noter que les DNS que j'utilise sont ceux de Cloudflare, ceux bloquant les malwares.

> IMPORTANT : L'accès à l'application n'est pas protégé par mot de passe dans cette configuration. Je vous propose de vous référer à la mise en place d'un serveur d'authentification [Authelia](/authelia-serveur-dauthentification-open-source/)

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisé avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) ne propose pas de fichier sample de configuration pour WG-Easy. Vous devez donc créer un fichier nommé `/opt/nginx/nginx/proxy-confs/wgeasy.subdomain.conf`, et y coller le contenu suivant : 

```txt
## Version 2024/07/16
# make sure that your wireguard container is named wireguard
# make sure that your dns has a cname set for wireguard

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name vpn.*;

    include /config/nginx/ssl.conf;

    client_max_body_size 0;

    # enable for ldap auth (requires ldap-location.conf in the location block)
    #include /config/nginx/ldap-server.conf;

    # enable for Authelia (requires authelia-location.conf in the location block)
    #include /config/nginx/authelia-server.conf;

    # enable for Authentik (requires authentik-location.conf in the location block)
    #include /config/nginx/authentik-server.conf;

    location / {
        # enable the next two lines for http auth
        #auth_basic "Restricted";
        #auth_basic_user_file /config/nginx/.htpasswd;

        # enable for ldap auth (requires ldap-server.conf in the server block)
        #include /config/nginx/ldap-location.conf;

        # enable for Authelia (requires authelia-server.conf in the server block)
        #include /config/nginx/authelia-location.conf;

        # enable for Authentik (requires authentik-server.conf in the server block)
        #include /config/nginx/authentik-location.conf;

        include /config/nginx/proxy.conf;
        include /config/nginx/resolver.conf;
        set $upstream_app wireguard;
        set $upstream_port 51821;
        set $upstream_proto http;
        proxy_pass $upstream_proto://$upstream_app:$upstream_port;

    }
}
```


Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Utilisation

Une fois votre service accessible, il est très simple d'ajouter des clients. Cliquez sur `Nouveau`, spécifiez un nom, et la configuration sera terminée... Vous pouvez télécharger la configuration générée pour l'ajouter à votre client. Et si c'est un mobile, il vous suffit d'afficher le QR Code afin de le faire scanner par l'application Wireguard de votre mobile.

{{< image src="/img/posts/wireguard-easy-simplifiez-la-gestion-de-wireguard/qrcode.webp" style="border-radius: 8px;" >}}

## Conclusion

Wireguard Easy est l’outil parfait pour administrer WireGuard. Avec son interface web conviviale et ses fonctionnalités bien pensées, il vous facilitera la gestion de vos clients VPN. Si vous avez besoin de davantage de modifications, je vous renvoie sur [la page du projet](https://github.com/wg-easy/wg-easy).
