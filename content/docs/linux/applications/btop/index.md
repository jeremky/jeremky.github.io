---
title: "btop"
slug: btop
contextMenu: true
weight: 33
toc: true
tags:
  - linux
draft: true
lastmod: 2026-09-06
---

[btop](https://github.com/aristocratos/btop) (aussi appelé btop++) est un moniteur de ressources système pour le terminal. Il affiche en temps réel le CPU, la mémoire, les disques, le réseau et les processus dans une interface colorée, réactive et entièrement pilotable à la souris.

## Installation

| Distribution  | Commande                |
| ------------- | ----------------------- |
| Debian/Ubuntu | `sudo apt install btop` |
| Fedora        | `sudo dnf install btop` |

> [!IMPORTANT]
> btop nécessite Debian 12 / Ubuntu 22.04 ou une version plus récente. Sur des versions antérieures, il faut passer par les backports ou compiler depuis les [sources](https://github.com/aristocratos/btop#compilation)

## Utilisation

### Lancer btop

```bash
btop
```

### Options en ligne de commande

| Option                    | Description                                    |
| ------------------------- | ---------------------------------------------- |
| `-c`, `--config <file>`   | Utilise un fichier de configuration spécifique |
| `-d`, `--debug`           | Active le mode debug (logs supplémentaires)    |
| `-f`, `--filter <filter>` | Définit un filtre de processus au démarrage    |
| `--force-utf`             | Force l'utilisation de l'UTF-8                 |
| `-l`, `--low-color`       | Limite l'affichage à 256 couleurs              |
| `-t`, `--tty`             | Force le mode TTY (couleurs limitées)          |
| `-u`, `--update <ms>`     | Définit l'intervalle de rafraîchissement (ms)  |

## Raccourcis clavier

| Raccourci          | Action                                                  |
| ------------------ | ------------------------------------------------------- |
| `Esc`, `m`         | Afficher/masquer le menu principal                      |
| `F1`, `?`, `h`     | Afficher l'aide                                         |
| `F2`, `o`          | Afficher les options                                    |
| `p`                | Preset de vue suivant                                   |
| `Shift + p`        | Preset de vue précédent                                 |
| `1`                | Afficher/masquer la boîte CPU                           |
| `2`                | Afficher/masquer la boîte MEM                           |
| `3`                | Afficher/masquer la boîte NET                           |
| `4`                | Afficher/masquer la boîte PROC                          |
| `5`                | Afficher/masquer la boîte GPU                           |
| `d`                | Afficher/masquer la vue disques dans la boîte MEM       |
| `+`, `-`           | Ajuster l'intervalle de rafraîchissement (±100 ms)      |
| `Ctrl + z`         | Mettre le programme en pause et en arrière-plan         |
| `Ctrl + r`         | Recharger la configuration depuis le disque             |
| `q`, `Ctrl + c`    | Quitter                                                 |
| `↑`, `↓`           | Sélectionner un processus dans la liste                 |
| `Entrée`           | Afficher les infos détaillées du processus sélectionné  |
| `Espace`           | Étendre/réduire le processus sélectionné (vue arbo)     |
| `C`                | Étendre/réduire les enfants du processus sélectionné    |
| `Pg Up`, `Pg Down` | Se déplacer d'une page dans la liste des processus      |
| `Home`, `End`      | Aller au début/à la fin de la liste des processus       |
| `←`, `→`           | Changer la colonne de tri                               |
| `f`, `/`           | Filtrer les processus (`!` en préfixe pour une regex)   |
| `F`                | Suivre le processus sélectionné                         |
| `u`                | Mettre en pause la liste des processus                  |
| `Suppr`            | Effacer le filtre en cours                              |
| `c`                | Afficher l'usage CPU par cœur pour les processus        |
| `r`                | Inverser l'ordre de tri                                 |
| `e`                | Basculer la vue arborescente des processus              |
| `E`                | Étendre/réduire tous les processus (vue arbo)           |
| `%`                | Changer le mode d'affichage de la mémoire               |
| `t` _(sélection)_  | Terminer le processus (SIGTERM)                         |
| `k` _(sélection)_  | Tuer le processus (SIGKILL)                             |
| `s` _(sélection)_  | Choisir et envoyer un signal au processus               |
| `N` _(sélection)_  | Changer la valeur nice du processus                     |
| `b`, `n`           | Sélectionner l'interface réseau précédente/suivante     |
| `i`                | Basculer le mode disques I/O avec grands graphiques     |
| `a`                | Basculer l'auto-scaling des graphiques réseau           |
| `y`                | Basculer le mode d'échelle synchronisée (réseau)        |
| `z`                | Réinitialiser les totaux de l'interface réseau courante |

## Configuration

btop génère automatiquement un fichier de configuration complet au premier lancement, avec toutes les options disponibles commentées. Il n'est donc pas nécessaire de tout redéfinir : seules les valeurs qui diffèrent des valeurs par défaut ont besoin de figurer dans le fichier.

Voici ce que je surcharge personnellement :

```vim {filename=".config/btop/btop.conf"}
#? Config file for btop

#* Theme name.
color_theme = "catppuccin"

#* Theme background.
theme_background = true

#* 24-bit color.
truecolor = true

#* Graph symbol.
graph_symbol = "block"
```

## Thèmes

Les thèmes personnalisés se placent dans `~/.config/btop/themes/`. La configuration peut être rechargée à chaud avec `Ctrl + r`, sans redémarrer btop.
