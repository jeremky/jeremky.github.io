---
title: "Executez des LLM en local avec Ollama et OpenWebUI"
date: 2025-03-30T18:15:25+02:00
cover: "/img/posts/executez-des-llm-en-local-avec-ollama-et-openwebui/cover.webp"
tags:
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: true
---

[Ollama](https://ollama.com/) est un framework open source conçu pour faciliter le déploiement de grands modèles de langage dans des environnements locaux. Disponible sur Windows, MacOS et Linux, il permet de récupérer directement des modèles via un système de dépôt.

Ollama peut être combiné à [Open WebUI](https://github.com/open-webui/open-webui), une interface web permettant d'interagir avec des modèles d'IA, tels que les grands modèles de langage (LLM). Cela simplifie l'utilisation de Ollama, en proposant une interface utilisateur graphique complète.

Dans cet article, nous allons donc voir comment déployer facilement ce duo avec Docker / Podman.

## Installation



### Reverse proxy

Les fichiers de configuration ci-dessus sont prévus pour être utilisé avec un reverse proxy.

> Pour rappel, un article dédié est [disponible ici](/posts/reverse-proxy-nginx/).

L'image Docker de [Linuxserver.io](https://docs.linuxserver.io/general/swag/) ne propose pas de fichier sample de configuration pour Open WebUI. Vous devez donc créer un fichier nommé `/opt/nginx/nginx/proxy-confs/ollama.subdomain.conf`, et y coller le contenu suivant :

```txt
## Version 2024/07/16

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name ollama.*;

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
        set $upstream_app ollama-webui;
        set $upstream_port 8080;
        set $upstream_proto http;
        proxy_pass $upstream_proto://$upstream_app:$upstream_port;

    }
}
```

> Pensez à changer la section `server_name ollama.*;` selon votre sous domaine.

Et enfin, un petit redémarrage pour la prise en compte du nouveau fichier :

```bash
sudo docker restart nginx
```
