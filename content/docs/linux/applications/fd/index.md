---
title: "fd"
slug: fd
contextMenu: true
weight: 15
toc: true
tags:
  - linux
draft: false
lastmod: 2026-08-16
---

[fd](https://github.com/sharkdp/fd) est une alternative moderne à `find`, avec une syntaxe plus simple et intuitive. Écrit en Rust, il ignore par défaut les fichiers cachés et respecte les règles `.gitignore`, tout en colorisant ses résultats.

## Installation

Sur Debian/Ubuntu :

```bash
sudo apt install fd-find
```

> [!IMPORTANT]
> Sur Debian/Ubuntu, le binaire est installé sous le nom `fdfind` pour éviter un conflit avec un paquet existant. Un alias `fd` peut être créé pour retrouver le nom d'origine

Sous Fedora :

```bash
sudo dnf install fd-find
```

## Utilisation

La syntaxe de base est la suivante :

```bash
fd <motif> <chemin>
```

Sans chemin, fd recherche récursivement dans le répertoire courant :

```bash
fd rapport
```

Par défaut, la recherche se fait uniquement sur le nom du fichier, pas sur le chemin complet.

## Options utiles

### Recherche sensible à la casse

Par défaut, fd est insensible à la casse. Pour forcer une recherche sensible à la casse :

```bash
fd -s motif
```

### Recherche dans les fichiers cachés

```bash
fd -H motif
```

### Filtrer par type

```bash
fd -t f motif
```

Les types disponibles sont notamment `f` (fichier), `d` (dossier), `l` (lien symbolique) et `x` (exécutable).

### Limiter la profondeur de recherche

```bash
fd -d 1 motif
```

### Recherche sur le chemin complet

Pour comparer le motif au chemin entier plutôt qu'au seul nom de fichier :

```bash
fd -p motif
```

### Exécuter une commande sur les résultats

L'option `-x` permet d'exécuter une commande pour chaque fichier trouvé :

```bash
fd -e log -x rm
```

Cet exemple supprime tous les fichiers avec l'extension `.log`.

### Filtrer par extension

```bash
fd -e conf
```

## Utilisation avec fzf

`fd` est souvent utilisé comme moteur de recherche pour [fzf](/docs/linux/applications/fzf), en remplacement de la commande `find` utilisée par défaut. Il suffit de définir la variable d'environnement suivante, par exemple dans son `.bashrc` ou `.zshrc` :

```bash
export FZF_DEFAULT_COMMAND='fd'
```

> [!NOTE]
> Sur Debian/Ubuntu, remplacez `fd` par `fdfind` (ou utilisez l'alias mis en place précédemment)

fzf devient alors plus rapide et respecte automatiquement le `.gitignore` lors de ses recherches interactives.
