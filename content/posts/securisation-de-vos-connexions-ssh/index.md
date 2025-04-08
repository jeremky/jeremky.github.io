---
title: Sécurisation de vos connexions SSH
slug: securisation-de-vos-connexions-ssh
date: 2024-05-19T17:16:47Z
useRelativeCover: true
cover: cover.webp
tags:
    - linux
categories:
    - Tutos
toc: true
draft: false
---

Dans cet article, nous allons voir comment sécuriser vos connexion SSH, en vous proposant de mettre en place un échange de clés, bien plus sécurisé qu'une simple authentification par mot de passe. Nous allons également mettre en place un fichier de configuration permettant l'utilisation de plusieurs clés.

## SSH c'est quoi ?

*SSH, ou Secure Socket Shell, est un protocole réseau qui permet aux administrateurs d'accéder à distance à un ordinateur, en toute sécurité. SSH désigne également l'ensemble des utilitaires qui mettent en oeuvre le protocole. Le protocole Secure Shell assure une authentification forte et des communications de données chiffrées sécurisées entre deux ordinateurs connectés sur un réseau peu sûr, tel qu'Internet. SSH est largement utilisé par les administrateurs réseau pour gérer à distance les systèmes et les applications, car il leur permet de se connecter à un autre ordinateur sur un réseau, d'exécuter des commandes et de déplacer des fichiers d'un ordinateur à un autre.*

## Création d'une clé

A noter que ce que je vais indiquer ici est valable aussi bien pour un client sous Linux, Mac, ou Windows (10 et 11).

Il existe différents algorithmes pour créer des clés. Le plus connu, le RSA. Toutefois, je vais vous proposer un algorithme plus récent, et surtout offrant un meilleur niveau de sécurité, le ed25519.

*"Ed25519 a pour but de fournir une résistance aux attaques comparable à celle des chiffrements de 128-bits de qualité. Les clés publiques sont encodées sur 256 bits (32 octets) de long et les signatures sont deux fois plus longues."*

Pour créer votre paire de clé de type ed25519, voici la commande à utiliser :

```bash
ssh-keygen -t ed25519 -a 100
```

Quelques questions vous seront posées :

- L'emplacement où générer les clés (vous pouvez laisser par défaut)
- Une passphrase à saisir (non obligatoire, mais recommandé)

{{< image src="gensshkey.webp" style="border-radius: 8px;" >}}

Une fois votre clé générée, nous allons utiliser la commande suivante pour l'ajouter au serveur que l'on souhaite :

```bash
ssh-copy-id -i .ssh/id_ed25519.pub <user>@<serveur>
```

Il vous faut spécifier la clé publique a utiliser, ainsi que le serveur de destination. Le mot de passe de connexion à ce dernier vous sera demandé.

{{< image src="copykey.webp" style="border-radius: 8px;" >}}

Une fois cela fait, vous pouvez retenter une connexion et profiter du résultat :sunglasses:

## Utiliser plusieurs clés

Afin d'augmenter davantage la sécurité, il est possible d'utiliser une clé par serveur SSH. Le plus simple, c'est de vous créer un fichier de config dédié. Ce fichier vous permettra même de vous créer des alias pour vos connexions distantes.

Le fichier, appelé `config`, est à créer sous dans votre dossier utilisateur, sous `.ssh` :

```txt
Host *
    AddKeysToAgent yes
    IdentitiesOnly yes

Host recalbox
    HostName recalbox.local
    User root
    Port 22
    IdentityFile ~/.ssh/id_recalbox
```

La 1ère partie s'applique à tous les hosts. Les éléments sont les suivants :

- `AddKeysToAgent` : ajoute le passphrase dans le trousseau du système, pour ne pas avoir à la ressaisir à chaque connexion
- `IdentitiesOnly` : spécifie à ssh de n'utiliser que les clés présentes dans ce fichier de config

Ensuite, vous pouvez créer un bloc par serveur distant, et y indiquer les éléments suivants :
- Le host : qui sera un alias pour vos connexions (la commande ssh recalbox suffira)
- Le hostname, qui peut être une IP
- Le user
- Le port à utiliser
- Et enfin la clé, qui a été renommée

Désormais, au lieu de devoir saisir ssh `<user>@<machine>`, vous pouvez maintenant saisir simplement `ssh <host>`

Les utilisateurs de Windows doivent activer le service `ssh-agent` pour permettre le stockage des passphrases :

```bash
Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service
```

## Côté serveur SSH

Maintenant que vous avez mis en place votre système de clé, il est possible de configurer le serveur SSH afin de n'accepter que les connexions via clé. Pour cela, il vous suffit d'éditer sur votre serveur le fichier `/etc/ssh/sshd_config` pour y décommenter la ligne suivante :

```txt
#PasswordAuthentication no
```

Dans le cas où vous avez utilisé mon script de configuration de debian, cette ligne se trouve dans le dernier bloc du fichier. Il suffit de changer la valeur à `no`.

Une fois la modification effectuée, une petite relance du service :

```bash
sudo systemctl restart sshd
```

Et avant de fermer votre session, ouvrez en une autre afin de vous assurer que vous pouvez toujours vous connecter... Cela vous évitera certaines mésaventures que j'ai pu expérimenter :sweat_smile:
