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

Afin de gagner un max de temps sur mes réinstallations de Debian, je me suis écrit un petit script qui installe les différents packages dont j'ai besoin et configure quelques éléments du système.

Vous pouvez récupérer le script en cliquant sur [ce lien](https://github.com/jeremky/aptinstall.sh/archive/refs/heads/main.zip).

## Prérequis

Une fois le script sur votre machine, vous devez tout d'abord modifier le fichier de configuration *aptinstall.cfg*. Il y a 2 éléments à modifier :

- Le nom de votre utilisateur. Cela est nécessaire pour la modification du serveur ssh de la machine, afin de limiter sshd à n'accepter que les connexions de l'utilisateur spécifié
- Les protocoles à autoriser à ufw. Ufw est un firewall très facile à utiliser. Vous pouvez lui indiquer un port à ouvrir, ou directement le nom d'un service, pour les plus connus. Dans le fichier fourni, vous avez déjà ssh en exemple, mais vous pouvez ajouter d’autres services, comme samba (séparez les services par des espaces). A noter une chose, il n'est pas nécessaire d'autoriser les ports utilisés par vos applications Docker, ufw les laisse passer

Une fois le fichier de configuration modifié, vous pouvez éditer le fichier *aptinstall.lst*. Ce fichier contient la liste des packages qui seront installés lors du lancement du script. Vous pouvez ajouter les votre, et commenter ou non ceux qui vous intéressent.

## Les packages proposés

| Package  | Description |
| -------- | ------- |
| apache2-utils       | utilisé pour générer des fichiers .htpasswd |
| certbot             | permet de générer des certificats auto-signés | 
| colordiff           | comme la commande diff, mais en couleur |
| cron                | planifacteur de tâches, pas toujours installé |
| curl                | outil de transfert web |
| docker.io           | docker, celui fourni par Debian |
| docker-compose      | pas encore intégré au docker de base |
| duf                 | comme df, mais en plus joli |
| fail2ban            | banni automatiquement les IP insistantes (écoute ssh par défaut) |
| htop                | comme top, mais en mieux |
| lftp                | un client ftp/sftp performant |
| lm-sensors          | un addon de htop, pour obtenir certaines infos supplémentaires |
| localepurge         | pour supprimer les fichiers de langue inutiles de votre système |
| mlocate             | la commande locate, un find amélioré |
| ncdu                | comme Treesize sous Windows |
| net-tools           | les commandes "de base" pour le réseau |
| p7zip               | pour dézipper du 7zip si nécessaire |
| ripgrep             | comme grep, mais en couleur et récursif |
| rsync               | pour effectuer de la synchro de dossiers |
| samba               | serveur de partage Windows |
| sshfs               | permet de monter directement en file system des connexions ssh |
| sudo                | gestionnaire de droits, pas toujours installé |
| sysstat             | les commandes "de base" pour du diagnostic système |
| tree                | affiche les sous-dossiers et fichiers en récursif |
| ufw                 | petit firewall simple d'utilisation |
| unzip               | pour décompresser du fichier zip |
| unattended-upgrades | permet d'installer automatiquement les mises à jour |
| vim                 | éditeur de fichiers Vi mais en amélioré |
| vim-youcompleteme   | une extension à Vim pour faire de l'autocomplétion |
| youtube-dl          | pour télécharger des vidéos Youtube en ligne de commande |
| zip                 | pour compresser du fichier zip |

## Les configurations automatisées

Une fois les packages installés, le script se chargera ensuite d'effectuer quelques opérations :

- Lancer la commande `updatedb` pour activer le fonctionnement de la commande `locate` (si installée)
- Lancer la configuration de `unattended-upgrades` (si installé). Il vous sera nécessaire de répondre à quelques questions pour sa mise en place
- Sécuriser le serveur SSH. Sans rentrer dans les détails, des paramètres y sont ajoutés afin de ne pas utiliser des éléments jugés peu sécurisés
- Activer le firewall UFW (si installé). Veillez donc à bien laisser le protocole ssh dans le fichier de configuration afin de ne pas perdre votre connexion...

Différentes questions vous seront posées lors de l’exécution du script, certaines étapes n’étant pas complètement automatisable.

Un dernier point au sujet de SSH : j'ai volontairement laissé l'autorisation de connexion par mot de passe. Toutefois, il est préférable d'utiliser des connexions par échange de clés ssh. Ce sera le sujet du prochain article.
