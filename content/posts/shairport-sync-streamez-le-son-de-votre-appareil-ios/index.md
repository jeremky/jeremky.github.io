---
title: "Shairport Sync : streamez le son de votre appareil iOS"
slug: shairport-sync-streamez-le-son-de-votre-appareil-ios
date: 2026-01-03T19:08:50.696Z
useRelativeCover: true
cover: cover.webp
tags:
  - linux
categories:
  - Tutos
toc: true
draft: true
---

Shairport Sync permet de transformer n’importe quelle machine Linux en récepteur AirPlay. Concrètement : vous envoyez le son de votre iPhone, iPad ou Mac directement vers votre PC branché à des enceintes.

## Installation

Shairport-sync est désormais disponible directement dans les dépôts des distributions majeures. Pour l'installer :

- Sur Fedora :

```bash
sudo dnf install shairport-sync
```

Si le paquet n’est pas disponible (selon version), activer EPEL :

```bash
sudo dnf install epel-release
sudo dnf install shairport-sync
```

- Sur Debian / Ubuntu :

```bash
sudo apt install shairport-sync
```

## Configuration

Le fichier principal :

```bash
/etc/shairport-sync.conf
```

Configuration minimale recommandée :

```txt
// Configuration File for Shairport Sync

// General Settings
general =
{
  name = "%h";

  volume_range_db = 50 ;
  volume_max_db = 0.0 ;
  default_airplay_volume = -30.0;
};

// Advanced parameters
sessioncontrol =
{
  allow_session_interruption = "yes";
  session_timeout = 120;
};

// Alsa Settings
alsa =
{
  output_device = "hw:1";
  mixer_control_name = "Headphone";
};
```

Redémarrage après modification :

```bash
sudo systemctl restart shairport-sync
```

## Intégration systemd

- Activer au démarrage :

```bash
sudo systemctl enable shairport-sync
```

- Démarrer :

```bash
sudo systemctl start shairport-sync
```

- Vérifier l’état :

```bash
systemctl status shairport-sync
```

## Test depuis iOS

1. Ouvrir le centre de contrôle
2. Appuyer sur AirPlay
3. Sélectionner le nom défini dans la config (hostname du serveur)

Le son bascule immédiatement.

Si rien n’apparaît :

- Vérifier que le firewall ne bloque pas mDNS
- Vérifier que `avahi-daemon` tourne

```bash
sudo systemctl status avahi-daemon
```
