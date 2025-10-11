---
title: Visual Studio Code dans son navigateur
slug: visual-studio-code-dans-son-navigateur
date: 2024-10-26T13:22:59.705Z
useRelativeCover: true
cover: cover.webp
tags:
  - docker
categories:
  - Tutos
toc: true
draft: false
---

D'après [Wikipedia](https://fr.wikipedia.org/wiki/Visual_Studio_Code),
*Visual Studio Code est un éditeur de code extensible développé par Microsoft pour
Windows, Linux et macOS.Les fonctionnalités incluent la prise en charge du débogage,
la mise en évidence de la syntaxe, la complétion intelligente du code (IntelliSense.),
les snippets, la refactorisation du code et Git intégré. Les utilisateurs peuvent
modifier le thème, les raccourcis clavier, les préférences et installer des extensions
qui ajoutent des fonctionnalités supplémentaires.*

Appelé code-server, cette version est utilisable directement depuis un navigateur.
L'intérêt ici est d'avoir une instance VS Code déportée de sa machine principale,
afin de pouvoir y accéder de n'importe où. A noter que cette solution n'est pas
multi utilisateur.

## Installation

Pour installer VS Code, voici les fichiers Docker/Podman nécessaires :

Le fichier `docker-compose.yml` :

```yml
services:
  code-server:
    image: lscr.io/linuxserver/code-server:latest
    container_name: code-server
    hostname: code-server
    env_file: code-server.env
    networks:
      - nginx_proxy
    volumes:
      - /opt/containers/code-server:/config
      - /opt/containers/code-server/workspace:/config/workspace
    restart: always

networks:
  nginx_proxy:
    external: true
```

Et le fichier `code-server.env` associé :

```bash
PUID=1000
PGID=1000
TZ=Europe/Paris
PASSWORD=
PROXY_DOMAIN=
DEFAULT_WORKSPACE=/config/workspace
```

> Pensez à adapter les volumes partagés dans le fichier `docker-compose.yml` et
les variables du fichier `code-server.env` selon votre convenance

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisés avec un
reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/)
propose un fichier sample de configuration, il vous suffit juste de modifier votre
nom de domaine en conséquence :

```bash
sudo cp /opt/containers/nginx/nginx/proxy-confs/code-server.subdomain.conf.sample /opt/containers/nginx/nginx/proxy-confs/code-server.subdomain.conf
sudo sed -i "s,server_name code-server,server_name <votre_sous_domaine>,g" /opt/containers/nginx/nginx/proxy-confs/code-server.subdomain.conf
```

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

La configuration proposée par le proxy apporte une fonctionnalité vraiment chouette :
si vous démarrez un serveur web via votre instance VS Code, et que vous avez configuré
la variable `PROXY_DOMAIN`, VS Code va automatiquement réacheminer vos ports
d'écoute vers un sous domaine.

 Pour mon utilisation avec le CMS Hugo, j'ai maintenant une url en `https://1313.mondomaine.com`
 (notez que le ssl s'active malgré un serveur de développement en http).

## Sécurisation par fichier htpasswd

L'image de [linuxserver.io](https://docs.linuxserver.io/images/docker-code-server/)
offre la possibilité de sécuriser l'accès à VS Code via une authentification par
mot de passe (voir fichier `code-server.env`). Personnellement, ayant plusieurs
applications à sécuriser, j'ai préféré opter pour une authentification par fichier
.`htpasswd`, afin de centraliser la gestion des mots de passe directement dans
la configuration du [reverse proxy](/posts/reverse-proxy-nginx/).

Pour créer votre fichier `.htpasswd`, utilisez les commandes suivantes :

```bash
sudo htpasswd -c /opt/containers/nginx/nginx/.htpasswd <votre user>
sudo chown 1000:1000: /opt/containers/nginx/nginx/.htpasswd
```

> Je considère que vous avez suivi le tuto pour la mise en place du reverse proxy,
le chemin et le user peuvent être différents selon votre configuration.

Une fois votre fichier `.htpasswd` créé, vous devez l'activer sur votre proxy.
Pour cela, modifiez le fichier `/opt/containers/nginx/nginx/proxy-confs/code-server.subdomain.conf`
et décommentez les lignes suivantes :

```nginx
auth_basic "Restricted";
auth_basic_user_file /config/nginx/.htpasswd;
```

Suivi d'un redémarrage du proxy pour prise en compte :

```bash
sudo docker container restart nginx
```

## Passer l'application en français

La langue française n'est pas installée par défaut sur cette instance VS Code.
Pour régler cela, Il suffit d'installer l'extension `French Language Pack for Visual Studio Code`.
Vous pourrez appliquer directement l'extension  et relancer l'application pour
appliquer le pack de langue.

Profitez-en pour installer l'extension `French - Code Spell Checker` afin d'avoir
la vérification syntaxique.

{{< image src="lang.webp" style="border-radius: 8px;" >}}

## Utilisation de git

Si vous avez besoin d'utiliser git dans votre instance VS Code, une configuration
est à effectuer dans les répertoires du conteneur. Si vous avez conservé le chemin
`/opt/containers/code-server`, créez y un fichier `.gitconfig` avec vos informations
d'utilisateur :

```txt
[user]
    name = foobar
    email = foo@bar.com
```

Créez ensuite un dossier `.ssh`, et dans ce dossier, créez un fichier `config`
avec le contenu suivant :

```txt
Host github.com
  HostName github.com
  User git
  Port 22
  IdentityFile ~/.ssh/id_github
```

Il vous reste à créer votre clé RSA, via la commande suivante :

```bash
ssh-keygen -t rsa -b 4096 -a 100
```

Lorsque c'est demandé, spécifiez le nom `id_github` et déplacez le dans `/opt/containers/code-server/.ssh`.
Il faut maintenant vous connecter sur github, et ajouter votre clé publique dans
`settings>SSH and GPG keys`, en cliquant sur `New SSH key`.

Dernière étape, lancez un terminal dans votre VS Code et lancer la commande
`ssh github.com` pour initialiser votre 1ère connexion SSH. Vous pourrez maintenant
synchroniser vos projets Github directement dans l'application :sunglasses:

## Conclusion

Cette solution me permet principalement de gérer les scripts et les fichiers de
ce site web présents sur mon serveur de manière plus flexible, notamment avec la
possibilité d'effectuer des synchronisations avec Github. A cela s'ajoute l'utilisation
de l'extension Front Matter, me permettant d'administrer ce site web de façon
bien plus conviviale.

{{< image src="frontmatter.webp" style="border-radius: 8px;" >}}

Toutefois, Cette solution à son lot de limitations, comme par exemple un manque de
packages intégrés dans l'image, ce qui peut rendre le développement avec certains
langages compliqué. Il est nécessaire de rebuild l'image à chaque changement si
on veut conserver les packages après mise à jour. J'ai également constaté que
certaines extensions n'étaient pas compatibles avec la version web.

Je recommande quand même de tester cette solution, l'expérience pouvant varier
selon vos besoins. Bon dev !
