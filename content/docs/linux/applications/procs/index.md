---
title: "procs"
slug: procs
contextMenu: true
weight: 32
toc: true
tags:
  - linux
draft: true
lastmod: 2026-08-30
---

[procs](https://github.com/dalance/procs) est un remplacement moderne pour `ps`, écrit en Rust. Plus rapide, plus lisible et bien plus puissant.

## Pourquoi utiliser procs ?

- Sortie colorée et adaptée au terminal (thème clair/sombre automatique)
- Recherche multi-colonnes par mots-clés
- Informations supplémentaires absentes de `ps` :
  - Ports TCP/UDP
  - Débit lecture/écriture
  - Nom des conteneurs Docker
  - Plus d’informations mémoire
- Mode watch (comme `top`)
- Vue arborescente des processus
- Support du pager automatique

## Installation

| Distribution  | Commande                 |
| ------------- | ------------------------ |
| Debian/Ubuntu | `sudo apt install procs` |
| Fedora        | `sudo dnf install procs` |

## Utilisation

### Afficher tous les processus

```bash
procs
```

### Rechercher un processus

```bash
procs nginx
```

### Mode watch (rafraîchissement automatique)

```bash
procs --watch
```

| Raccourci | Action                    |
| --------- | ------------------------- |
| `n`       | Colonne de tri suivante   |
| `p`       | Colonne de tri précédente |
| `a`       | Tri ascendant             |
| `d`       | Tri descendant            |
| `q`       | Quitter                   |

### Vue arborescente

```bash
procs --tree
```

### Tri par colonne

```bash
procs --sortd cpu
procs --sorta rss
```

## Colonnes disponibles (kind list)

procs propose un grand nombre de colonnes personnalisables.

| Kind        | Description             | Équivalent `ps` |
| ----------- | ----------------------- | --------------- |
| `Pid`       | ID du processus         | `pid`           |
| `Command`   | Commande complète       | `args`          |
| `User`      | Utilisateur             | `euser`         |
| `State`     | État du processus       | `s`             |
| `UsageCpu`  | Utilisation CPU         | `%cpu`          |
| `UsageMem`  | Utilisation mémoire     | `%mem`          |
| `VmRss`     | Mémoire résidente       | `rss`           |
| `VmSize`    | Taille virtuelle        | `vsz`           |
| `TcpPort`   | Ports TCP ouverts       | –               |
| `UdpPort`   | Ports UDP ouverts       | –               |
| `ReadBytes` | Octets lus              | –               |
| `WriteByte` | Octets écrits           | –               |
| `Docker`    | Nom du conteneur Docker | –               |
| `StartTime` | Heure de démarrage      | `start_time`    |
| `CpuTime`   | Temps CPU cumulé        | `cputime`       |
| `Threads`   | Nombre de threads       | `nlwp`          |

> **Note** : La liste complète est disponible avec `procs --list` ou dans la [documentation officielle](https://github.com/dalance/procs#kind-list).

## Configuration

Fichier de configuration :

- Linux : `~/.config/procs/config.toml`
- macOS : `~/Library/Preferences/com.github.dalance.procs/config.toml`

Générer une configuration par défaut :

```bash
procs --gen-config > ~/.config/procs/config.toml
```
