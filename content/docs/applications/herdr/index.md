---
title: "Herdr"
slug: herdr
contextMenu: true
weight: 60
toc: true
tags:
  - linux
  - macos
draft: false
lastmod: 2026-10-16
---

[Herdr](https://herdr.dev/) est un multiplexeur de terminal écrit en Rust, pensé pour travailler avec des agents IA en ligne de commande (Claude Code, Codex...). Il fonctionne directement dans votre terminal habituel, à la manière de tmux, et en reprend d'ailleurs une bonne partie des concepts : préfixe, onglets, panneaux, sessions détachables...

Sa particularité est de **détecter automatiquement les agents IA** lancés dans ses panneaux et d'afficher leur état en temps réel dans une barre latérale : en cours de travail, en attente d'une réponse, ou terminé. Pratique pour faire tourner plusieurs agents en parallèle sans devoir passer son temps à vérifier chaque onglet.

## Installation

### macOS

La méthode la plus simple reste d'utiliser brew. Un article [disponible ici](/docs/macos/utilisation-de-homebrew) a été rédigé à son sujet.

Une fois brew installé, lancez la commande suivante :

```bash
brew install herdr
```

### Linux

Herdr propose un script d'installation, qui fonctionne également sur macOS :

```bash
curl -fsSL https://herdr.dev/install.sh | sh
```

> [!NOTE]
> D'autres méthodes d'installation (Nix, Windows, binaires précompilés...) sont détaillées dans la [documentation officielle](https://herdr.dev/docs/install/)

Une fois installé, il suffit de lancer la commande `herdr` depuis votre terminal.

## Les concepts

Herdr organise votre travail en plusieurs niveaux :

- **Workspaces** : un espace de travail par projet, listé dans la barre latérale
- **Onglets** : chaque workspace peut contenir plusieurs onglets
- **Panneaux** : chaque onglet peut être découpé en plusieurs panneaux (splits)

Comme sous tmux, la plupart des raccourcis s'utilisent en 2 temps : un appui sur la touche **préfixe** (`Ctrl + b` par défaut), suivi de la touche de l'action.

La session est gérée par un serveur tournant en arrière-plan : vous pouvez vous détacher de Herdr, fermer votre terminal, puis vous rattacher plus tard en retrouvant vos workspaces et vos agents dans l'état où vous les avez laissés.

## Les commandes de base

Voici les raccourcis par défaut les plus utiles, à faire précéder de la touche préfixe :

| Raccourci             | Action                                                      |
| --------------------- | ----------------------------------------------------------- |
| `v` / `-`             | Diviser le panneau verticalement / horizontalement          |
| `h` / `j` / `k` / `l` | Se déplacer vers le panneau de gauche / bas / haut / droite |
| `x`                   | Fermer le panneau courant                                   |
| `z`                   | Agrandir / réduire le panneau courant (zoom)                |
| `c`                   | Créer un nouvel onglet                                      |
| `p` / `n`             | Onglet précédent / suivant                                  |
| `1` à `9`             | Aller directement à l'onglet correspondant                  |
| `Shift + n`           | Créer un nouveau workspace                                  |
| `w`                   | Ouvrir le sélecteur de workspaces                           |
| `b`                   | Afficher / masquer la barre latérale                        |
| `[`                   | Entrer en mode copie                                        |
| `q`                   | Se détacher de la session                                   |
| `s`                   | Ouvrir les paramètres                                       |
| `Shift + r`           | Recharger la configuration                                  |

> [!NOTE]
> Le raccourci `préfixe + ?` affiche la liste complète des raccourcis disponibles

## Configuration

La configuration de Herdr s'effectue via un fichier `toml` à créer dans le dossier `~/.config/herdr` :

```bash
mkdir -p ~/.config/herdr
touch ~/.config/herdr/config.toml
```

> [!NOTE]
> Pour consulter l'ensemble des options et leurs valeurs par défaut, vous pouvez générer une configuration complète avec la commande `herdr --default-config`. Je vous conseille cependant de ne conserver que les paramètres que vous modifiez, afin de garder un fichier lisible

### Exemple de configuration

Voici la configuration que j'utilise :

```toml {filename="~/.config/herdr/config.toml"}
# ─── herdr ───────────────────────────────────────────────────────────────

onboarding = false

[theme]
name = "catppuccin"

[update]
version_check = false

[ui]
mouse_capture = true
copy_on_select = true
prompt_new_tab_name = false
hide_tab_bar_when_single_tab = true
pane_scrollbars = false

[ui.toast]
delivery = "herdr"

[ui.sound]
enabled = true

[keys]
prefix = "ctrl+space"
previous_tab = "ctrl+w"
next_tab = "ctrl+x"
previous_workspace = "ctrl+q"
next_workspace = "ctrl+s"
new_workspace = "ctrl+shift+space"

[session]
resume_agents_on_restore = true
```

Ce fichier permet notamment :

- de désactiver l'assistant de premier lancement ainsi que la vérification des mises à jour
- d'utiliser le thème [Catppuccin](/docs/linux/theme-catppuccin) (embarqué nativement dans Herdr)
- de copier automatiquement le texte sélectionné à la souris
- de créer un onglet sans demander son nom, et de masquer la barre d'onglets lorsqu'il n'y en a qu'un seul
- de masquer les barres de défilement à côté des panneaux
- d'afficher les notifications directement dans Herdr, accompagnées d'un son lorsqu'un agent change d'état
- de relancer automatiquement les conversations des agents après un redémarrage du serveur

### Raccourcis clavier

La section `[keys]` redéfinit la touche préfixe ainsi que la navigation entre onglets et workspaces, qui ne nécessite plus de passer par le préfixe :

| Raccourci                | Action                         |
| ------------------------ | ------------------------------ |
| `Ctrl + Espace`          | Touche préfixe                 |
| `Ctrl + w` / `Ctrl + x`  | Onglet précédent / suivant     |
| `Ctrl + q` / `Ctrl + s`  | Workspace précédent / suivant  |
| `Ctrl + Shift + Espace`  | Créer un nouveau workspace     |

> [!IMPORTANT]
> Ces raccourcis sont interceptés par Herdr et ne sont donc plus transmis aux applications lancées dans les panneaux (par exemple `Ctrl + w` dans un shell, qui supprime le mot précédent)

Pour voir toutes les options disponibles, consultez la [documentation officielle](https://herdr.dev/docs/config-reference/).
