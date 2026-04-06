---
title: "Activer HTTP/3 sur un reverse proxy sous Docker"
slug: activer-http3-sur-un-reverse-proxy-docker
date: 2025-07-30T14:56:09+02:00
useRelativeCover: true
cover: cover.webp
tags:
  - docker
  - reseau
categories:
  - Tutos
toc: true
draft: false
---

D'après Cloudflare, HTTP/3 améliore nettement les performances, la fiabilité et la sécurité des sites web, sans aucun changement de code côté applicatif. Il repose sur QUIC, un protocole de transport basé sur UDP, pensé pour les connexions mobiles ou instables.

Dans cet article, nous allons donc voir comment modifier la configuration du reverse proxy NGINX proposé par [Linuxserver.io](https://docs.linuxserver.io/general/swag/). Si besoin, vous pouvez consulter [cet article](/posts/reverse-proxy-nginx/) pour connaître son fonctionnement.

> EDIT : Malheureusement, avec Podman en mode rootless, les performances de téléchargement sont grandement impactées

## Installation

Petit rappel de l'installation. La seule différence avec le fichier `compose.yml` d'origine, c'est l'ajout de l'écoute du port 443 en UDP.
Voici donc le fichier à jour :

```yml
services:
  nginx:
    image: lscr.io/linuxserver/swag:latest
    container_name: nginx
    hostname: nginx
    env_file: nginx.env
    cap_add:
      - NET_ADMIN
    networks:
      - proxy
    volumes:
      - /opt/containers/nginx:/config
    ports:
      - 80:80
      - 443:443/tcp
      - 443:443/udp
    restart: always

networks:
  proxy:
    external: false
```

J'en profite pour vous rappeler le contenu du fichier `nginx.env` associé :

```bash
PUID=1000
PGID=1000
TZ=Europe/Paris
URL=mondomaine.fr
SUBDOMAINS=auth,www
VALIDATION=http
EMAIL=foo@bar.com
ONLY_SUBDOMAINS=false
```

## Configuration

Une fois votre conteneur déployé, vous devriez trouver sous `/opt/containers/nginx/nginx` les différents fichiers de configuration. Dans ce répertoire, nous allons commencer par modifier le fichier `ssl.conf`.

La ligne qui nous intéresse principalement, c'est la ligne suivante :

```txt
add_header Alt-Svc 'h3=":443"' always;
```

Je vous conseille de décommenter également les lignes suivantes, pour augmenter la sécurité de votre reverse proxy :

```txt
add_header Strict-Transport-Security "max-age=63072000" always;

add_header Permissions-Policy "interest-cohort=()" always;
add_header Referrer-Policy "same-origin" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
```

Passons maintenant à la configuration du site principal. Rien de compliqué, vous avez juste à décommenter la ligne suivante dans le bloc principal du fichier `/opt/containers/nginx/nginx/site-confs/default.conf`:

```txt
listen 443 quic reuseport default_server;
```

Et ensuite, pour chaque sous domaine, modifiez votre fichier de configuration en conséquence (fichiers présents sous `/opt/containers/nginx/nginx/proxy-confs`). Par exemple dans un fichier de configuration pour Tinyauth :

```txt
listen 443 quic;
```

> A noter que si vous utilisez IPV6, vous devez bien sûr décommenter aussi les lignes le concernant

Redémarrez enfin votre conteneur pour appliquer les modifications :

```bash
docker restart nginx
```

## Firewall

Si vous utilisez un firewall, pensez à autoriser le port 443 en UDP. Par exemple avec ufw :

```bash
sudo ufw allow 443/udp
```

Si vous êtes sûr de garder cette configuration, vous pouvez remplacer la règle spécifique à 443/tcp par une règle unique pour 443 (TCP et UDP). Pour cela, commencez par lister les règles actives :

```bash
sudo ufw status numbered
```

Récupérez le numéro correspondant à 443/tcp pour la supprimer :

```bash
sudo ufw delete <numéro>
```

Puis ajoutez le port 443 pour TCP et UDP :

```bash
sudo ufw allow 443
```

## Tester votre site

Vous pouvez tester votre nouvelle configuration sur un site spécialement conçu à cet effet : [http3check](https://http3check.net/). Vous devriez obtenir un retour de ce genre :

{{< image src="check.webp" style="border-radius: 8px;" >}}

## Conclusion

HTTP/3 permet de gagner en performance, surtout sur mobile ou en réseau instable. Son activation dans un reverse proxy Docker est simple si on utilise une image compatible et que l’on pense à ouvrir le port UDP 443.
L'image fournie par [Linuxserver](https://www.linuxserver.io/) reste à mes yeux la solution la plus robuste et la plus simple à déployer.

> À noter : certains reverse proxies comme [Caddy](https://caddyserver.com/) intègrent HTTP/3 nativement, mais je n'ai pas eu l'occasion de le tester pour le moment.
