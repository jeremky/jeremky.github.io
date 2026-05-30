---
title: "ChimeraOS"
slug: chimeraos
contextMenu: true
weight: 10
toc: true
tags:
  - jeux
  - linux
draft: false
lastmod: 2026-05-30
---

[ChimeraOS](https://chimeraos.org/) est un système d'exploitation conçu pour transformer un PC en console de jeux, **clé en main**. Après l'installation, démarrez directement sur **Steam Big Picture**, connectez votre compte Steam et lancez vos jeux préférés.

![chimeraos](https://chimeraos.org/logo.svg)

## Fonctionnalités

- Installation simple en quelques minutes : démarrez sur votre nouveau système de gaming instantanément

- Utilisez l'application web intégrée pour installer et gérer vos jeux depuis n'importe quel appareil

- Mises à jour régulières en arrière plan  pour les pilotes et logiciels les plus récents

- Interface 100% compatible avec les manettes (prise en charge des manettes Xbox, PlayStation…)

- Compatible avec Steam, Epic Games Store, GOG, et des dizaines de plateformes de consoles (émulation)

## Compatibilité

Avant de vous lancer dans son installation, il est important de noter que l’interface Linux de Valve n’est officiellement compatible qu’avec une carte graphique AMD.
Pour les possesseurs d’une carte nVidia ou Intel, je vous conseille de vous rediriger vers une alternative, comme [Bazzite](https://bazzite.gg/) ou [Nobara](https://nobaraproject.org/).

## Installation

1. Récupérez l'iso à [cette page](https://chimeraos.org/download/)

2. Chargez-la sur une clé USB en utilisant l'outil [Etcher](https://etcher.balena.io/)

3. Suivez les instructions de l'installateur

> La dernière version de l'OS sera téléchargée pendant le processus d'installation.

## Configuration

ChimeraOS dispose d'une interface web vous permettant d'effectuer certaines opérations. Vous pourrez y configurer vos connexions à Epic Games et Gog, afin d'installer facilement vos jeux et de les importer dans l'interface de Steam. Cette même interface vous permettra également d'ajouter directement vos ROMs. ChimeraOS utilise [RetroArch](https://retroarch.com/) pour l'exécution de vos jeux.

![library](library.webp)

Pour vous y connecter, rendez-vous à l'adresse suivante : <https://chimeraos.local:8844>. Un mot de passe temporaire s'affichera à l'écran afin de vous y connecter. Pour définir un mot de passe, rendez-vous dans la section `system`.

![password](password.webp)

### Connexion SSH

Le système étant immuable, le mot de passe de l’utilisateur n’est pas modifiable. Pour se connecter en SSH, la seule méthode est d'utiliser une clé SSH. Pour cela :

{{% steps %}}

#### Générez une paire de clés ed25519

``` bash
ssh-keygen -t ed25519 -a 100
```

#### Copiez le contenu de la clé publique

```bash
cat ~/.ssh/id_ed25519.pub
```

#### Rendez-vous sur la page de ChimeraOS

Rendez-vous depuis votre appareil à l'adresse suivante : <http://chimeraos.local:8844/system> (ou en utilisant l'adresse IP si l'utilisation du nom DNS local ne fonctionne pas).

#### Ajoutez-y votre clé publique

Rendez-vous dans la section `ssh` et copiez le contenu du fichier `id_ed25519.pub` que vous avez généré.

![ssh](ssh.webp)

#### Connexion

Il ne vous reste plus qu'à tenter une connexion ssh avec l'outil de votre choix :

```bash
ssh gamer@chimeraos.local
```

{{% /steps %}}

> Pour plus d’informations au sujet des clés ssh, vous pouvez vous rendre à [cette page](/docs/linux/securisation-de-ssh)

### Problème CPU

J’ai constaté des problèmes de [throttling](https://fr.wikipedia.org/wiki/Ajustement_dynamique_de_la_fr%C3%A9quence) avec la machine de récupération me servant de console. Les réglages dans son bios étant extrêmement limités, je ne peux pas forcer le mode performance pour le CPU.

Si vous êtes concerné par ce même problème, connectez vous en ssh et vérifiez que le changement de mode de cpupower règle le problème :

```bash
sudo cpupower frequency-set -g performance
```

Si vous observez un nombre de FPS plus stable, il ne reste qu’à créer un service systemd pour l’appliquer à chaque démarrage.

#### Service systemd

Le système étant immuable, il n’est pas possible de modifier la configuration directement dans les fichiers système. La solution trouvée est de faire exécuter un service systemd par le user gamer :

{{% steps %}}

##### Créez le fichier systemd

```bash
mkdir -p ~/.config/systemd/user
nano cpupower.service
```

##### Insérez le contenu suivant

```systemd {filename="~/.config/systemd/user/cpupower.service"}
[Unit]
Description=Force CPU performance

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo "gamer" | sudo -S /usr/bin/cpupower frequency-set -g performance'

[Install]
WantedBy=default.target
```

##### Activez le service

```bash
systemctl --user enable --now cpupower.service
```

{{% /steps %}}

## Suivre le projet

Pour suivre ce projet, rendez-vous sur [GitHub](https://github.com/ChimeraOS/chimeraos).
