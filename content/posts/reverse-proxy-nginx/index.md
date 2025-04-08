---
title: Reverse Proxy NGINX
date: 2023-09-04T17:06:51Z
useRelativeCover: true
cover: cover.webp
tags:
  - reseau
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

Sur [Wikipedia](https://fr.wikipedia.org/wiki/Proxy_inverse), il est dit qu'*un proxy inverse (reverse proxy) ou serveur mandataire inverse est un type de serveur, habituellement placé en frontal de serveurs web. Contrairement au serveur proxy qui permet à un utilisateur d'accéder au réseau Internet, le proxy inverse permet à un utilisateur d'Internet d'accéder à des serveurs internes.*

L'intérêt dans notre cas, est de pouvoir disposer de différentes applications Web conteneurisées, et de n'avoir qu'un seul accès Web en front. De plus, la mise en place d'un reverse proxy offre également ces avantages :

- Permettre l'accès aux applications via des sous domaines, plutôt que par un port spécifique
- Forcer l'accès aux applications en SSL, même si les applications ne le prennent pas en charge
- Mettre en place un réseau virtuel : seul le proxy aura accès aux applications

## Déploiement du reverse proxy NGINX

La team [Linuxserver](https://docs.linuxserver.io/general/swag) fournit une image appelée SWAG (pour *Secure Web Application Gateway*). Par rapport à une image NGINX classique, les avantages sont les suivants :

- Création automatisée des certificats SSL via Let's Encrypt
- Intégration de PHP
- Activation de l'outil Fail2ban (pour bannir temporairement les IP abusant des requêtes http)
- Mise à disposition de fichiers sample pour tout un tas d'applications

Voici le contenu de mon fichier `docker-compose.yml` :

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
      - /opt/nginx:/config
    ports:
      - 80:80
      - 443:443
    restart: always

networks:
  proxy:
    external: false
```

Et le fichier `nginx.env` pour les variables :

```txt
PUID=1000
PGID=1000
TZ=Europe/Paris
URL=mondomaine.fr
SUBDOMAINS=www,nextcloud
VALIDATION=http
EMAIL=foo@bar.com
ONLY_SUBDOMAINS=false
```

> IMPORTANT : si vous avez d'autres sous domaines à ajouter par la suite, il faudra supprimer et réinstaller le conteneur. La variable ne sera pas mise à jour dans le cas contraire.

Vous pouvez maintenant tester votre serveur web. En contactant l'IP ou votre domaine, vous devriez tomber sur la page par défaut :

{{< image src="default.webp" style="border-radius: 8px;" >}}

## Configuration de vos conteneurs

Votre proxy étant en place, vous devez maintenant modifier vos conteneurs pour qu'ils se trouvent dans le même réseau virtuel. Nous allons reprendre l'exemple de Nextcloud présent dans l'article au sujet de [Docker Compose](/posts/utilisation-de-docker-compose/). Le fichier `docker-compose.yml` est désormais le suivant :

```yml
services:
  nextcloud-db:
    image: docker.io/postgres:16.4
    container_name: nextcloud-db
    hostname: nextcloud-db
    networks:
      - default
    env_file: nextcloud-db.env
    volumes:
      - /opt/nextcloud/postgres:/var/lib/postgresql/data
    restart: always

  nextcloud:
    image: lscr.io/linuxserver/nextcloud:latest
    container_name: nextcloud
    hostname: nextcloud
    networks:
      - default
      - nginx_proxy
    env_file: nextcloud.env
    volumes:
      - /opt/nextcloud/config:/config
      - /opt/nextcloud/data:/data
    depends_on:
      - nextcloud-db
    restart: always

networks:
  default:
    external: false
  nginx_proxy:
    external: true
```

A la fin du fichier, on lui spécifie quels réseaux seront à créer. Dans notre cas, il ne doit créer que "default" (qui s'appellera en réalité `nextcloud_default`), mais doit avoir accès au réseau `nginx_proxy` (external à *true*).
Ensuite, pour chaque service, on lui spécifie quel(s) réseau(x) utiliser. La base de donnée n'est que dans le réseau network, et la partie web dans les 2. Le reverse proxy aura donc accès à l'application Web mais pas à la base.

> Vous remarquerez que les ports ne sont plus spécifiés pour le service nextcloud. Il n'est en effet plus nécessaire d'ouvrir l'accès : celui-ci se fera uniquement par le proxy.

## Ajout d'une configuration NGINX

Maintenant que vous avez redéployé votre application dans le bon réseau (nginx_proxy), il ne reste plus qu'à définir une configuration dans NGINX pour pointer vers celle-ci. Si vous avez laissé le dossier de déploiement par défaut, tout doit se trouver dans `/opt/nginx`.

Dans ce dossier, vous pouvez vous rendre dans `nginx/proxy-confs`. Ici se trouve tout un tas de fichier "sample" proposés par Linuxserver, certaines applications ayant des spécificités de configuration.
Vous y trouverez un fichier `nextcloud.subdomain.conf.sample`. Copiez-le en `nextcloud.subdomain.conf`. Le contenu de ce fichier :

```txt
## Version 2023/06/24
# make sure that your nextcloud container is named nextcloud
# make sure that your dns has a cname set for nextcloud
# assuming this container is called "swag", edit your nextcloud container's config
# located at /config/www/nextcloud/config/config.php and add the following lines before the ");":
#  'trusted_proxies' => ['swag'],
#  'overwrite.cli.url' => 'https://nextcloud.example.com/',
#  'overwritehost' => 'nextcloud.example.com',
#  'overwriteprotocol' => 'https',
#
# Also don't forget to add your domain name to the trusted domains array. It should look somewhat like this:
#  array (
#    0 => '192.168.0.1:444', # This line may look different on your setup, don't modify it.
#    1 => 'nextcloud.example.com',
#  ),

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name nextcloud.*;

    include /config/nginx/ssl.conf;

    client_max_body_size 0;

    location / {
        include /config/nginx/proxy.conf;
        include /config/nginx/resolver.conf;
        set $upstream_app nextcloud;
        set $upstream_port 443;
        set $upstream_proto https;
        proxy_pass $upstream_proto://$upstream_app:$upstream_port;

        # Hide proxy response headers from Nextcloud that conflict with ssl.conf
        # Uncomment the Optional additional headers in SWAG's ssl.conf to pass Nextcloud's security scan
        proxy_hide_header Referrer-Policy;
        proxy_hide_header X-Content-Type-Options;
        proxy_hide_header X-Frame-Options;
        proxy_hide_header X-XSS-Protection;

        # Disable proxy buffering
        proxy_buffering off;
    }
}
```

Si votre conteneur pour la partie web s'appelle "nextcloud", et que votre sous domaine également, vous n'avez rien de plus à faire, juste à redémarrer le conteneur nginx :

```bash
sudo docker restart nginx
```

Votre application devrait maintenant être accessible !

## Particularité avec Podman

Si vous utilisez Podman à la place de Docker, une modification est à effectuer dans la configuration de l'image pour éviter d'avoir aléatoirement des erreurs 502.

Après avoir déployé votre conteneur nginx, rendez-vous dans `/opt/nginx/nginx` et modifiez le fichier `resolver.conf`, pour y supprimer la 2ème adresse IP au niveau de la ligne `resolver`. Le fichier doit ressembler à ceci :

```txt
# This file is auto-generated only on first start, based on the container's /etc/resolv.conf file.   Feel free to modify it as you wish.

resolver  10.89.0.1 valid=30s;
```

## Conclusion

L'utilisation de sous domaines via un reverse proxy rend l'utilisation de vos différentes applications plus confortables. Cela évite d'avoir des ports différents à saisir dans vos url. Et l'image de linuxserver facilite grandement la génération de certificats valides.
