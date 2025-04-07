---
title: Utilisation de transfer.sh
date: 2023-10-12T17:07:52Z
cover: /img/posts/utilisation-de-transfer.sh/cover.webp
tags:
  - docker
  - podman
categories:
  - Tutos
toc: false
draft: false
---

Je ne sais pas pour vous, mais il m'est (trop) souvent arrivé d'avoir un fichier à transférer rapidement sans trop savoir comment. On avait les bonnes vieilles méthodes, que ce soit l'envoi via mail, un Google Drive, ou des services dédiés genre WeTransfer... Mais faut soit créer un compte, soit on est limité à une taille de fichier, à un nombre de transferts par mois... Sans compter que selon là où se trouve le fichier que l'on veut transférer (un serveur sans interface graphique par exemple...), on doit d'abord le récupérer sur notre poste pour ensuite l'envoyer... C'est là qu'intervient transfer.sh

[transfer.sh](https://transfer.sh/) est un service permettant d'envoyer des fichiers directement via un terminal, en utilisant la commande curl, ou la cmdlet Invoke-WebRequest en PowerShell. Cela fonctionne également par glissé déposé dans le navigateur web, même si ce n'est pas l'objectif original.

## Utilisation

Pour simplifier l'utilisation, le service propose des exemples de commandes à utiliser. Il propose également une fonction à coller dans votre fichier d'environnement (bash_aliases par exemple) :

```bash
transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}
```

## Hébergement

Vous pouvez héberger transfer.sh sur votre serveur. Vous vous en douterez, grâce... à une image Docker :smirk:

Le fichier `docker-compose.yml` :

```yml
services:
  transfer:
    image: docker.io/dutchcoders/transfer.sh:latest
    container_name: transfer
    hostname: transfer
    networks:
      - nginx_proxy
    env_file: transfer.env
    volumes:
      - /opt/transfer:/tmp
    command: --provider local
    restart: always

networks:
  nginx_proxy:
    external: true
```

Et son fichier `transfer.env` :


```txt
BASEDIR=/tmp
PURGE_DAYS=1
PURGE_INTERVAL=24
MAX_UPLOAD_SIZE=10485770
EMAIL_CONTACT=foo@bar.com
```

L'image offre une configuration assez flexible, afin de choisir le temps de conservation des données, la limite d'upload des fichiers, le stockage à utiliser... Si vous voulez connaitre les possibilités, je vous laisse consulter la documentation [ici](https://github.com/dutchcoders/transfer.sh).

Je vous souhaite donc un bon transfert ! :blush:
