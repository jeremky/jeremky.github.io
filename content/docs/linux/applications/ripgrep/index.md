---
title: "ripgrep"
slug: ripgrep
contextMenu: true
weight: 35
toc: true
tags:
  - linux
draft: true
lastmod: 2026-06-17
---

[ripgrep](https://github.com/BurntSushi/ripgrep) (ou `rg`) est une alternative moderne à `grep`, orientée recherche récursive dans des répertoires. Écrit en Rust, il est particulièrement rapide et respecte par défaut les règles `.gitignore`, en ignorant automatiquement les fichiers cachés et les binaires.

## Installation

Sur Debian/Ubuntu :

```bash
sudo apt install ripgrep
```

Sous Fedora :

```bash
sudo dnf install ripgrep
```

## Utilisation

La syntaxe de base est la suivante :

```bash
rg <motif> <chemin>
```

Sans chemin, ripgrep recherche récursivement dans le répertoire courant :

```bash
rg "ma recherche"
```

## Options utiles

### Recherche insensible à la casse

```bash
rg -i "motif"
```

### Afficher uniquement les noms de fichiers

```bash
rg -l "motif"
```

### Limiter la recherche à un type de fichier

```bash
rg -t py "motif"
```

Les types disponibles peuvent être listés avec `rg --type-list`.

### Exclure un type de fichier

```bash
rg -T py "motif"
```

### Recherche dans les fichiers cachés

Par défaut, ripgrep ignore les fichiers et dossiers cachés. Pour les inclure :

```bash
rg --hidden "motif"
```

### Recherche avec expression régulière

ripgrep supporte nativement les expressions régulières :

```bash
rg "\d{3}-\d{4}" fichier.txt
```

### Afficher le contexte autour des résultats

```bash
rg -C 3 "motif"
```

Les options `-B` (before) et `-A` (after) permettent de contrôler le contexte avant et après séparément.

### Remplacer dans l'affichage

Pour prévisualiser un remplacement sans modifier les fichiers :

```bash
rg "ancien" --replace "nouveau"
```