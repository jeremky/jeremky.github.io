---
title: "Flame : un Dashboard léger et efficace"
slug: flame-un-dashboard-leger-et-efficace
date: 2024-11-23T20:42:50.155Z
useRelativeCover: true
cover: cover.webp
tags:
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: false
---

Il y a quelques mois, j'avais fait la présentation de l'application [Heimdall](/posts/creer-son-dashboard-avec-heimdall/). Ce dashboard est joli et simple à configurer. Mais dans l'utilisation, je trouvais qu'il manquait de productivité. J'ai donc regardé les alternatives et je suis tombé sur le dashboard Flame.

[Flame](https://github.com/pawelmalak/flame) est un dashboard ultra minimaliste, se concentrant sur son efficacité. Ses points forts : 
- Il permet de regrouper ses applications web et ses favoris au même endroit
- Les applications Docker peuvent automatiquement être ajoutées et retirées du dashboard, via des labels à ajouter à vos fichiers `compose.yml`
- Il dispose d'une barre de recherche unifiée, permettant de trouver rapidement un élément, et dans le cas contraire, vous renvoi sur le moteur de recherche de votre choix

## Installation

Cela devient redondant maintenant, mais vous vous en doutez :

Un fichier `compose.yml` :

```yml
services:
  dashboard:
    image: docker.io/pawelmalak/flame
    container_name: flame
    hostname: flame
    env_file: flame.env
    networks:
      - nginx_proxy
    volumes:
      - ./files:/app/data
      - /var/run/docker.sock:/var/run/docker.sock:ro
    secrets:
      - password
    restart: always

networks:
  nginx_proxy:
    external: true

secrets:
  password:
    file: ./.password
```

Et son fichier `flame.env` :

```txt
PASSWORD_FILE=./.password
```

2 choses importantes à noter : 
- Dans les volumes, se trouve le lien avec le fichier `docker.sock`. Cela permet à Flame de visualiser les labels des autres conteneurs, pour l'ajout automatique au dashboard. Si vous utilisez Podman, remplacez cette ligne par la suivante : 
`/var/run/podman/podman.sock:/var/run/docker.sock:ro`
- Vous remarquerez la présence de l'entrée `secrets`. J'en reparlerai plus tard, mais sachez que vous devez créer un fichier `.password` et y saisir un mot de passe. Via cette méthode, votre mot de passe ne sera pas visible dans les variables d'environnement du conteneur

### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisés avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) ne propose pas de fichier sample de configuration pour Flame. Vous devez donc créer un fichier nommé `/opt/nginx/nginx/proxy-confs/flame.subdomain.conf`, et y coller le contenu suivant : 

```txt
## Version 2024/07/16
# make sure that your wireguard container is named flame
# make sure that your dns has a cname set for flame

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name flame.*;

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
        set $upstream_app flame;
        set $upstream_port 5005;
        set $upstream_proto http;
        proxy_pass $upstream_proto://$upstream_app:$upstream_port;

    }
}
```

> Pensez à changer la section `server_name flame.*;` selon votre sous domaine.

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```

## Configuration

Au 1er lancement de Flame, vous vous retrouverez sur une page austère vous proposant de vous rendre sur `/settings`. Il vous sera demandé de vous connecter pour accéder aux paramètres. Pour retourner plus tard sur la page des paramètres, une icône se trouve tout en bas à gauche.

### Theme

Dans l'onglet `Theme`, un choix de base vous est proposé, mais vous pouvez également créer le votre. Vous pouvez également spécifier un thème par défaut.

### General

Dans l'onglet `General`, il est possible de spécifier comment trier les différents éléments, et choisir le comportement de la barre de recherche. Par défaut, la recherche se fait d'abord dans vos éléments locaux, et renvoie votre requête vers le moteur de recherche de votre choix si aucun résultat n'est trouvé.

### Interface

Cet onglet permet de modifier les éléments d'affichage principaux. C'est assez austère et particulier sur ce point. Je vous partage donc les éléments à remplacer pour une traduction en français.

- `Custom greetings` : 

*Bonsoir !;Bonjour !;Bonjour !;Bonsoir !*

- `Custom weekday names` : 

*Dimanche;Lundi;Mardi;Mercredi;Jeudi;Vendredi;Samedi*

- `Custom month names` : 

*Janvier;Février;Mars;Avril;Mai;Juin;Juillet;Août;Septembre;Octobre;Novembre;Décembre*

Enfin, vous pouvez choisir d'afficher ou non les sections `Applications` et `Bookmarks`.

### Weather

Pour ajouter l'icône de météo, il faut disposer d'un compte chez [Weather API](https://www.weatherapi.com/pricing.aspx). Le compte gratuit suffit largement, le nombre de requêtes ne sera jamais dépassé. Une fois votre compte créé, récupérez la clé d'API pour l'ajouter dans la configuration de Flame.

Pour la localisation, utilisez le système de localisation en cliquant sur `Click to get current location`.

### Docker

Dans cette section, vous pouvez comme vu plus haut ajouter/retirer automatiquement vos applications Docker. Activez `Use Docker API` et `Unpin stopped containers / other apps`.

Pour que Flame sache comment ajouter les applications, il est nécessaire de modifier vos fichier `compose.yml`, et y ajouter une section `labels`. Exemple avec Portainer : 

```yml
services:
  portainer:
    image: docker.io/portainer/portainer-ce:sts
    container_name: portainer
    hostname: portainer
    labels:
      - flame.type=application
      - flame.name=Portainer
      - flame.url=https://portainer.domaine.fr
      - flame.icon=docker
```

> Le nom des icônes est à récupérer sur le site [Pictogrammers](https://pictogrammers.com/library/mdi/)

### CSS

Enfin, l'onglet CSS vous permet de modifier en détail des éléments d'interface. Je vous partage mes quelques modifications :

```css
/* Taille de police */
body {
    font-size: 16px !important;
}

/* Taille du message */
.Header_Header__GCJdR h1 {
    font-size: 3em !important;
}

/* Largeur du contenu */
.Layout_Container__HIHX7 {
        width: 95% !important;
}

/* Supprimer l'URL des apps */
.AppCard_AppCardDetails__HgNoY span {
    display: none !important;
}

/* Comportement des tuiles */
.AppCard_AppCard__NPTM5 {
    padding: 16px !important;
    margin-bottom: 0 !important;
    border-radius: 0.5rem !important;
}

/* Style du bouton settings */
.Home_SettingsButton__DrUPz {
    border-radius: 0.5rem !important;
}
```

Petit bonus si vous désirez un fond d'écran :

```css
/* Fond d'écran */
body:before {
    content: "";
    position: fixed;
    overflow: hidden;
    background-image: url("<url>");
    background-size: cover;
    z-index: -999;
    height: 100%;
    width: 100%;
    transform: scale(1.1);
}
```

> Pour le fond d'écran, vous pouvez récupérer une url sur le site [WallpapersCraft](https://wallpaperscraft.com/)

## Ajout de vos éléments

Maintenant que Flame est configuré, il ne reste plus qu'à l'alimenter !

Si vous avez redémarré vos conteneurs après y avoir ajouté la section `labels`, vous devriez déjà avoir la 1ère section déjà alimentée. Il ne vous reste plus qu'à ajouter vos bookmarks.

Cliquez sur `Bookmarks`, et créez les catégories et les favoris que vous désirez :

{{< image src="add.webp" style="border-radius: 8px;" >}}

## Conclusion

Voici quelques rendus possibles une fois la configuration de Flame terminée :

{{< image src="exemple1.webp" style="border-radius: 8px;" >}}
***
{{< image src="exemple2.webp" style="border-radius: 8px;" >}}
***
{{< image src="exemple3.webp" style="border-radius: 8px;" >}}
