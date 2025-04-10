---
title: "Authelia : serveur d'authentification Open Source"
slug: authelia-serveur-dauthentification-open-source
date: 2024-11-11T23:34:44.392Z
useRelativeCover: true
cover: cover.webp
tags:
  - admin
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

D'après le [site officiel](https://www.authelia.com/), *"Authelia est un serveur et un portail d'authentification open source remplissant le rôle de gestion des identités et des accès (IAM) en fournissant une authentification multifacteur et une authentification unique (SSO) pour vos applications via un portail Web. Il agit comme un compagnon pour les proxys inverses courants."*

Dans cet article, il sera présenté comment installer Authelia, et comment le connecter au reverse proxy nginx (voir [cet article](/posts/reverse-proxy-nginx/) pour l'installation de nginx). A noter que cet article se concentre uniquement sur une configuration simple permettant de remplacer l'authentification par fichier `.htpasswd` interne à nginx.

## Installation

Pour l'installation, un fichier `docker-compose.yml` :

```yml
services:
  authelia:
    image: docker.io/authelia/authelia:latest
    container_name: authelia
    hostname: authelia
    env_file: authelia.env
    user: 1000:1000
    networks:
      - nginx_proxy
    volumes:
      - /opt/authelia:/config
    restart: always

networks:
  nginx_proxy:
    external: true
```

Et son fichier `authelia.env` :

```txt
TZ=Europe/Paris
```

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisés avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) propose un fichier sample de configuration, il vous suffit juste de modifier votre nom de domaine en conséquence :

```bash
sudo cp /opt/nginx/nginx/proxy-confs/authelia.subdomain.conf.sample /opt/nginx/nginx/proxy-confs/authelia.subdomain.conf
sudo sed -i "s,server_name authelia,server_name <votre_sous_domaine>,g" /opt/nginx/nginx/proxy-confs/authelia.subdomain.conf
```

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Configuration

Avant de démarrer le conteneur, il est nécessaire de préparer le fichier de configuration de l'application. Les étapes présentées ici seront à adapter selon vos modifications du fichier `docker-compose.yml`.

Tout d'abord, créez le dossier `/opt/authelia` :

```bash
sudo mkdir /opt/authelia
```

Ensuite, créez un fichier nommé `configuration.yml` avec le contenu suivant :

```txt
## Theme : light, dark, grey, auto.
theme: dark

server:
  address: tcp://0.0.0.0:9091/authelia
  buffers.read: 4096
  buffers.write: 4096

log:
  level: info
  file_path: /config/authelia.log

telemetry:
  metrics:
    enabled: false

identity_validation.reset_password.jwt_secret: <clé aléatoire>

authentication_backend:
  password_reset.disable: true
  file:
    path: /config/users.yml
    password:
      algorithm: argon2id
      iterations: 1
      key_length: 32
      salt_length: 16
      memory: 512
      parallelism: 8

access_control:
  default_policy: deny
  rules:
    - domain:
      - "dom1.domaine.fr"
      policy: one_factor
      subject:
        - ['group:user']
    - domain:
      - "dom2.domaine.fr"
      - "dom3.domaine.fr"
      policy: one_factor
      subject:
        - ['group:admin']

totp:
  disable: false

session:
  name: authelia_session
  secret: <clé secrète>
  expiration: 2h
  inactivity: 1h
  remember_me: 1M
  cookies:
    - domain: domaine.fr
      authelia_url: https://auth.domaine.fr

regulation:
  max_retries: 3
  find_time: 2m
  ban_time: 5m

storage:
  encryption_key: <clé secrète>
  local:
    path: /config/db.sqlite3

notifier:
  filesystem:
    filename: /config/mails.txt
```

Les éléments à modifier : 

- Remplacez `domaine.fr` par votre domaine, ainsi que le sous domaine configuré pour Authelia (`auth.domaine.fr`)
- Remplacez chaque clé secrète par des passphrases générées aléatoirement (vous pouvez vous rendre sur [ce site](https://passwordsgenerator.net/) pour cela)
- Selon vos préférences, vous pouvez changer le temps d'expiration et d'inactivité dans la section `session`
- Si vous souhaitez utilisez de la double authentification, il suffit de remplacer la policy `one_factor` par `two_factor` dans la section `access_control`

Si vous voulez autoriser le changement de mot de passe, sachez qu'un "mail" sera généré dans le fichier `/opt/authelia/mails.txt`. Si vous voulez mettre en place une gestion d'envoi de mails, il faut modifier la section `notifier` de la façon suivante : 

```txt
notifier:
  smtp:
    address: <serveur smtp>
    timeout: 5s
    username: <user>
    password: <password>
    sender: <mail>
    tls.skip_verify: false
    subject: '[Authelia] {title}'
    startup_check_address: <mail>
```

### Utilisateurs

Vos utilisateurs sont à renseigner dans un fichier nommé `/opt/authelia/users.yml` :

```txt
users:
  user1:
    displayname: "user1"
    password: "password_a_generer"
    email: user1@mail.com
    groups:
      - user

  user2:
    displayname: "user2"
    password: "password_a_generer"
    email: user2@mail.com
    groups:
      - user
      - admin
```

Dans cet exemple, `user1` n'a accès qu'à dom1.domaine.fr, et `user2` a accès à `dom1.domaine.fr`, `dom2.domaine.fr`, et `dom3.domaine.fr`. 

#### Génération des mots de passe

Pour générer une version chiffrée du mot de passe, utilisez la commande suivante :

```bash
sudo docker run --rm docker.io/authelia/authelia:latest authelia crypto hash generate argon2 --password 'votre_password'
``` 

Insérez le résultat à la ligne correspondante.

### Configuration de nginx

Vous devez maintenant activer Authelia dans vos fichiers de configuration présents dans `/opt/nginx/nginx/proxy-confs` pour protéger les services souhaités. 2 lignes sont à décommenter.

Dans le bloc `server` :

```txt
include /config/nginx/authelia-server.conf;
```

Et dans le bloc `location` :

```txt
include /config/nginx/authelia-location.conf;
```

Redémarrez ensuite nginx pour prise en compte : 

```bash
sudo docker restart nginx
```

En vous rendant sur l'application où cette modification a été effectuée, vous devriez tomber désormais sur la page de connexion d'Authelia :

{{< image src="login.webp" style="border-radius: 8px;" >}}

## Conclusion

Comparé à des alternatives comme [Keycloak](https://www.keycloak.org/) ou [Authentik](https://goauthentik.io/), Authelia propose une solution vraiment légère pour une installation personnelle, malgré une configuration bien plus austère.

Cependant, cette solution telle que décrite dans cet article ne propose pas de configuration de type OpenID/Oauth. Authelia a subit pas mal de changements dans ses dernières versions, et les articles permettant ce genre de configuration ne sont pas légion... Cela pourrait être un sujet d'article à l'avenir, mais je préfère pour le moment utiliser la gestion par mot de passe interne aux applications qui le permettent.

En attendant, vous avez maintenant une protection centralisée de vos services auto hébergés qui ne disposent pas de protection par mot de passe.
