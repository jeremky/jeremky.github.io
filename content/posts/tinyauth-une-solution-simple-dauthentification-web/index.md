---
title: "Tinyauth : une solution simple d'authentification web"
slug: tinyauth-une-solution-simple-authentification-web
date: 2025-07-26T08:41:09.872Z
useRelativeCover: true
cover: cover.webp
tags:
  - docker
categories:
  - Tutos
toc: true
draft: true
---

Quand on auto-héberge des services, il est souvent nécessaire de restreindre l’accès à certaines interfaces, panneaux d’administration, dashboards, API internes, etc.

Plutôt que d’implémenter un reverse proxy complet avec base d’utilisateurs, ou de déployer une solution comme Authelia ou Keycloak, j’ai cherché une alternative minimaliste, légère et rapide à mettre en place.

C'est ici qu'intervient [Tinyauth](https://github.com/frevib/tinyauth), un outil écrit en Go qui se comporte comme un reverse proxy HTTP avec authentification par fichier. Son usage est plus limité mais conviendra sûrement à ceux qui cherchent une solution élégante et simple.

## Fonctionnalités

Tinyauth propose les fonctionnalités suivantes : 

- Déploiement ultra rapide via Docker/Podman
- Possibilité de créer des users locaux directement dans les variables d'environnement (donc pas besoin de gérer un fichier de config)
- Interfaçage avec des services d'authentification externe, comme du LDAP, du Oauth via Github, Google...
- De la double authentification TOTP

## Installation

Pour l'installer, rien de nouveau. Un fichier `compose.yml` :

```yml
services:
  tinyauth:
    image: ghcr.io/steveiliop56/tinyauth:latest
    container_name: tinyauth
    hostname: tinyauth
    env_file: tinyauth.env
    networks:
      - nginx_proxy
    restart: always

networks:
  nginx_proxy:
    external: true
```

Le fichier `tinyauth.env` associé : 

```bash
SECRET=<clé_secrète>
APP_URL=https://tinyauth.mondomaine.fr
DISABLE_CONTINUE=true
APP_TITLE=JeremKy Auth
USERS=<à remplir plus tard>
```

Pour générer une clé secrète aléatoire, utilisez la commande suivante : 

```bash
openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32 && echo
```

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisés avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) propose un fichier sample de configuration, il vous suffit juste de modifier votre nom de domaine en conséquence :

```bash
sudo cp /opt/containers/nginx/nginx/proxy-confs/tinyauth.subdomain.conf.sample /opt/containers/nginx/nginx/proxy-confs/tinyauth.subdomain.conf
```

### Configuration de nginx

Vous devez maintenant activer Tinyauth dans vos fichiers de configuration présents dans `/opt/containers/nginx/nginx/proxy-confs` pour protéger les services souhaités. 2 lignes sont à décommenter.

Dans le bloc `server` :

```nginx
include /config/nginx/tinyauth-server.conf;
```

Et dans le bloc `location` :

```nginx
include /config/nginx/tinyauth-location.conf;
```

Redémarrez ensuite nginx pour prendre en compte vos modifications :

```bash
docker restart nginx
```

## Configuration

### Utilisateurs

Maintenant que Tinyauth est installé, nous allons créer nos utilisateurs. On aurait pu les créer en amont, mais il dispose d'un outil intégré permettant de générer facilement la ligne à insérer dans le fichier `tinyauth.env`.

Pour cela, connectez vous au conteneur fraîchement démarré : 

```bash
docker exec -it tinyauth sh
```

Et lancez la commande suivante : 

```bash
./tinyauth user create -i
```

Renseignez les éléments demandés (tabulation pour suivant) :

{{< image src="user.webp" style="border-radius: 8px;" >}}

Spécifiez que vous voulez un format pour docker, pour que le hash du mot de passe soit compatible. Vous allez avoir dans le retour une ligne de ce type :

```bash
testuser:$$2a$$10$$0fsXGdP6yfivZixOlpE.VOzjrheliau3x6f1Q1PyOJwtiTfnzGogG
```

Modifiez le fichier `tinyauth.env` pour ajouter ce user à la variable USERS. Vous pouvez en ajouter plusieurs en les séparant par des virgules

Redéployez votre Tinyauth pour prendre en compte la nouvelle variable. Cela devrait être tout bon ! Vous devriez pouvoir profitez de votre nouveau service !

{{< image src="login.webp" style="border-radius: 8px;" >}}

### TOTP

Si vous voulez ajouter une double authentification TOTP, utilisez la commande suivante dans votre conteneur : 

```bash
./tinyauth totp generate -i
```

Il vous sera demandé de saisir la ligne créée précédemment. Vous allez vous retrouver avec un ENORME QR Code dans votre terminal :smile:.

Mais c'est surtout la ligne en dessous qui va nous intéresser : 

```bash
testuser:$$2a$$10$$0fsXGdP6yfivZixOlpE.VOzjrheliau3x6f1Q1PyOJwtiTfnzGogG:54JVQL5HDB7T2F7NO27JHLT2S2ITKHJN
```

La ligne contient désormais la clé en plus du mot de passe. Remplacez la ligne dans le fichier `tinyauth.env` et le tour est joué.

Après un redéploiement :

{{< image src="totp.webp" style="border-radius: 8px;" >}}

### Github OAuth

Si vous ne voulez pas avoir à gérer les mots de passe utilisateur, Tinyauth permet d'utiliser un service externe pour permettre la connexion. Il est compatible avec les services suivants : 

- [OAuth Github](https://tinyauth.app/docs/guides/github-oauth)
- [OAuth Google](https://tinyauth.app/docs/guides/google-oauth)
- [Service LDAP](https://tinyauth.app/docs/guides/ldap)

Dans cet exemple, nous allons utiliser Github OAuth pour effectuer la connexion. La documentation de Tinyauth est vraiment bien faite, je vous laisse aller voir sur [le site](https://tinyauth.app/docs/guides/github-oauth) pour la création de l'application côté Github.

Une fois votre configuration en place, vous devez modifier votre fichier `tinyauth.env` pour y ajouter les variables suivantes : 

```bash
OAUTH_WHITELIST=adresse@mail.com
GITHUB_CLIENT_ID=<id_app>
GITHUB_CLIENT_SECRET=<secret_key>
```

- `OAUTH_WHITELIST` : Le(s) compte(s) autorisé(s) (A spécifier, car sinon, tous les utilisateurs ayant un compte pourront se connecter)
- `GITHUB_CLIENT_ID` : L'ID de votre application créée sur Github
- `GITHUB_CLIENT_SECRET` : La clé générée dans la configuration de votre app Github

> Vous pouvez maintenant supprimer la variable `USERS` du fichier `tinyauth.env` si vous ne voulez pas conserver la méthode d'authentification classique

Après un redéploiement de Tinyauth, il devrait désormais vous proposer la connexion via Github : 

{{< image src="github.webp" style="border-radius: 8px;" >}}

## Conclusion

Grâce à Tinyauth, vous pouvez très facilement sécuriser l'accès à vos services. La mise en place est rapide et simple. Combiné à l'authentification via un service tiers, vous profitez d'une sécurité élevée.

Toutefois, cette simplicité n'est pas sans inconvénients. Impossible de gérer localement de l'authentification OAuth, ou de gérer finement les droits de vos utilisateurs. Si ces besoins sont indispensable pour vous, je vous conseille plutôt de vous orienter vers [Authelia](https://jeremky.github.io/posts/authelia-serveur-dauthentification-open-source/).