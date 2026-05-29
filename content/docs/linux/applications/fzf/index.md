---
title: "Fzf"
slug: fzf
contextMenu: true
weight: 10
toc: true
tags:
  - linux
draft: false
lastmod: 2026-05-29
---

[fzf](https://github.com/junegunn/fzf) est un outil de recherche interactive en ligne de commande. Il intercepte n'importe quelle liste en entrée et affiche une interface de sélection permettant de filtrer les résultats en temps réel avec une correspondance approximative. Il s'intègre nativement avec bash pour enrichir la complétion de commandes et la recherche dans l'historique.

## Installation

fzf est disponible dans les dépôts Debian/Ubuntu :

```bash
sudo apt install fzf
```

## Configuration

L'intégration de fzf dans bash se fait en ajoutant la ligne suivante dans le fichier `.bash_aliases` ou `.bashrc` :

```bash
# fzf : recherche avancée
if [[ -f /usr/bin/fzf ]]; then
  eval "$(fzf --bash)"
  export FZF_DEFAULT_OPTS="--color=bw"
fi
```

La variable `FZF_DEFAULT_OPTS` permet de personnaliser l'apparence et le comportement par défaut. Ici, `--color=bw` désactive les couleurs pour un rendu sobre.

Pour la prise en compte :

```bash
source ~/.bashrc
```

## Utilisation

Une fois intégré à bash, fzf ajoute trois raccourcis clavier :

| Raccourci  | Description                                                              |
| ---------- | ------------------------------------------------------------------------ |
| `Ctrl + T` | Recherche interactive de fichiers dans le répertoire courant             |
| `Ctrl + R` | Recherche interactive dans l'historique des commandes                    |
| `Alt + C`  | Navigation interactive dans les sous-répertoires                         |

Il est également possible d'appeler `fzf` directement dans le terminal pour filtrer n'importe quelle sortie :

### Sélectionner un fichier et l'ouvrir dans vim

```bash
# Sélectionner un fichier et l'ouvrir dans vim
vim $(fzf)
```

### Rechercher dans les processus actifs

```bash
ps aux | fzf
```
