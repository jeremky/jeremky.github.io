---
title: Script de configuration pour Debian
slug: script-de-configuration-pour-debian
date: 2024-05-12T17:15:46Z
useRelativeCover: true
cover: cover.webp
tags:
    - linux
categories:
    - Tutos
toc: true
draft: false
---

Afin de gagner un max de temps sur mes réinstallations de Debian, je me suis écrit
un petit script qui installe les différents packages dont j'ai besoin et configure
quelques éléments du système.

Vous pouvez récupérer le script en cliquant sur [ce lien](https://github.com/jeremky/pkginstall/archive/refs/heads/main.zip).

## Prérequis

Une fois l'archive récupérée, vous pouvez éditer le fichier `config/debian.lst`.
Ce fichier contient la liste des packages qui seront installés lors du lancement
du script. Vous pouvez ajouter les votre, et commenter ou non ceux qui vous intéressent.

## Les packages proposés

| Package  | Description |
| -------- | ------- |
| colordiff           | comme la commande diff, mais en couleur |
| cron                | planifacteur de tâches, pas toujours installé |
| curl                | outil de transfert web |
| duf                 | comme df, mais en plus joli |
| fail2ban            | banni automatiquement les IP insistantes (écoute ssh par défaut) |
| fd-find             | comme find, mais en mieux |
| fzf                 | outil de recherche avancé |
| htop                | comme top, mais en mieux |
| ncdu                | comme Treesize sous Windows |
| net-tools           | les commandes "de base" pour le réseau |
| pipes-sh            | un écran de veille dans votre terminal |
| plocate             | recherche de fichiers avancé |
| preload             | apprend de votre utilisation pour anticiper les chargements |
| ripgrep             | comme grep, mais en couleur et récursif |
| rsync               | pour effectuer de la synchro de dossiers |
| sudo                | gestionnaire de droits, pas toujours installé |
| sysstat             | les commandes "de base" pour du diagnostic système |
| tmux                | multiplexeur de terminal |
| tree                | affiche les sous-dossiers et fichiers en récursif |
| ufw                 | petit firewall simple d'utilisation |
| unzip               | pour décompresser du fichier zip |
| unattended-upgrades | permet d'installer automatiquement les mises à jour |
| vim                 | éditeur de fichiers Vi mais en amélioré |
| zip                 | pour compresser du fichier zip |
| zoxide              | commande cd intelligente |

## Les configurations automatisées

Une fois les packages installés, le script se chargera ensuite d'effectuer quelques opérations :

- Lancer la commande `updatedb` pour activer le fonctionnement de la commande `locate`
(si installée)
- Lancer la configuration de `unattended-upgrades` (si installé). Il vous sera nécessaire
de répondre à quelques questions pour sa mise en place
- Sécuriser le serveur SSH. Sans rentrer dans les détails, des paramètres y sont
ajoutés afin de ne pas utiliser des éléments jugés peu sécurisés. A noter que
seul l'utilisateur principal sera autorisé (ID 1000)
- Activer le firewall UFW (si installé). Veillez donc à bien laisser le protocole
ssh dans le fichier de configuration afin de ne pas perdre votre connexion...

Un dernier point au sujet de SSH : j'ai volontairement laissé l'autorisation de
connexion par mot de passe. Toutefois, il est préférable d'utiliser des connexions
par échange de clés ssh. Ce sera le sujet du prochain article.

> Cet article a été mis à jour suite à la modification du script, qui prend également
en charge la distribution fedora
