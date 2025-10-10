---
title: "AriaNG : centralisez vos téléchargements"
slug: ariang-centralisez-vos-telechargements
date: 2024-12-13T18:07:03.000Z
useRelativeCover: true
cover: cover.webp
tags:
  - fichiers
  - docker
categories:
  - Tutos
toc: true
draft: false
---

Récemment, je vous ai présenté [Transmission](/posts/transmission-un-client-torrent-web/),
un outil web de téléchargement de fichiers torrent.
Mais son intérêt a pris un sacré coup dans l’aile depuis que je suis tombé sur [AriaNG](https://github.com/hurlenko/aria2-ariang-docker).

AriaNG vous permet de centraliser la gestion de vos téléchargements, indépendamment
du protocole : HTTP(s), FTP/SFTP, Bittorent, Metalink…

## Installation

Pour installer AriaNG, les fichiers pour Docker sont les suivants :

```yml
services:
  ariang:
    image: docker.io/hurlenko/aria2-ariang:latest
    container_name: ariang
    hostname: ariang
    env_file: ariang.env
    networks:
      - nginx_proxy
    volumes:
      - /opt/containers/ariang:/aria2/data
      - ./files:/aria2/conf
    restart: always

networks:
  nginx_proxy:
    external: true
```

> Dans l’exemple, le volume du dossier des téléchargements est `/opt/containers/ariang`,
mais vous pouvez très bien le placer dans votre dossier utilisateur.

Le fichier `ariang.env` associé :

```bash
PUID=1000
PGID=1000
ARIA2RPCPORT=443
```

> A noter qu’il est préférable d’utiliser l’id 1000, surtout si vous placez le dossier
de téléchargements dans votre dossier personnel.

### Reverse Proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisés avec
un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L’image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/)
ne propose pas de fichier sample de configuration pour cette version de AriaNG.
Vous devez donc créer un fichier nommé `/opt/containers/nginx/nginx/proxy-confs/ariang.subdomain.conf`,
et y coller le contenu suivant :

```nginx
## Version 2024/07/16
# make sure that your AriaNG container is named ariang
# make sure that your dns has a cname set for ariang

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name ariang.*;

    include /config/nginx/ssl.conf;

    client_max_body_size 0;

    # enable for ldap auth (requires ldap-location.conf in the location block)
    #include /config/nginx/ldap-server.conf;

    # enable for Authelia (requires authelia-location.conf in the location block)
    #include /config/nginx/authelia-server.conf;

    # enable for Authentik (requires authentik-location.conf in the location block)
    #include /config/nginx/authentik-server.conf;

    location / {
        #include /config/nginx/authelia-location.conf;
        include /config/nginx/proxy.conf;
        include /config/nginx/resolver.conf;
        set $upstream_app ariang;
        set $upstream_port 8080;
        set $upstream_proto http;
        proxy_pass $upstream_proto://$upstream_app:$upstream_port;
    }

    location ~ (/ariang)?/jsonrpc {
        include /config/nginx/proxy.conf;
        include /config/nginx/resolver.conf;
        set $upstream_app ariang;
        set $upstream_port 6800;
        set $upstream_proto http;
        proxy_pass $upstream_proto://$upstream_app:$upstream_port/jsonrpc;
    }

}
```

> Pensez à changer la section `server_name ariang.*;` selon votre sous domaine.

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Démarrage

Au 1er lancement de la page, assurez vous que le service web se soit correctement
connecté à aria2 :

{{< image src="aria2.webp" style="border-radius: 8px;" >}}

Vous pouvez ensuite ajouter vos téléchargements :smile:

{{< image src="add.webp" style="border-radius: 8px;" >}}

Comme vu dans la capture, il est possible de lui balancer directement des liens
de fichiers torrent. Il va se charger de télécharger le fichier et lancer
le téléchargement dans la foulée :

{{< image src="download.webp" style="border-radius: 8px;" >}}

## Conclusion

Je vous laisserai parcourir les réglages si vous avez besoin. Je n’ai pas pris le
temps de présenter les options possibles, la configuration de base lui permet
d’être totalement fonctionnel en l’état.
