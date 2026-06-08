---
title: "Ghostty"
slug: ghostty
contextMenu: true
weight: 30
toc: true
tags:
  - macos
draft: false
lastmod: 2026-05-29
---

[Ghostty](https://ghostty.org/) est un émulateur de terminal moderne, rapide et natif sur macOS. Créé par Mitchell Hashimoto (co-fondateur de HashiCorp, l'auteur de Terraform et Vagrant), il est sorti en open source fin 2024 et a rapidement conquis la communauté des développeurs. Voici comment l'installer, le configurer et en tirer le meilleur parti.

Là où des terminaux comme Hyper ou Tabby s'appuient sur Electron (et donc un moteur Chromium complet), **Ghostty utilise nativement AppKit et SwiftUI sur macOS**. Résultat : une empreinte mémoire faible, un rendu GPU fluide via Metal, et un comportement conforme aux conventions macOS (drag-and-drop natif, raccourcis système, Quick Look, Secure Input API...).

## Installation

La façon la plus simple d'installer Ghostty sur Mac est via Homebrew. S'il n'est pas encore installé sur votre machine, je vous recommande de vous rendre sur [cette page](/docs/macos/utilisation-de-homebrew).

> si vous préférez télécharger le `.dmg`, il est disponible [ici](https://ghostty.org/download)

## Configuration

Ghostty ne dispose pas d'interface de configuration. Tout se fait via un fichier texte. Pour respecter le nouvel emplacement, je vous recommande de créer le fichier au préalable :

```bash
mkdir -p ~/.config/ghostty
touch ~/.config/ghostty/config
```

Vous pourrez ensuite l'ouvrir directement depuis Ghostty, via le raccourci **`Cmd + ,`**.

### Exemple de configuration

Voici la configuration que j'utilise :

```ini {filename="~/.config/ghostty/config"}
###############################################################
## Ghostty

# general
auto-update = on
confirm-close-surface = false
bell-features = no-attention,no-title,no-audio,no-system
shell-integration-features = no-cursor,ssh-env

# macos
macos-titlebar-proxy-icon = hidden
macos-titlebar-style = tabs

# window
window-width = 124
window-height = 30
window-padding-x = 20
window-padding-y = 10

# appearance
theme = Catppuccin Mocha
unfocused-split-opacity = 0.90
adjust-cell-height = 10%

# font
font-family = JetBrains Mono NL
font-thicken = false
font-size = 17

# mouse
mouse-scroll-multiplier = discrete:1
mouse-hide-while-typing = true

# clipboard
copy-on-select = clipboard
right-click-action = copy-or-paste

# quick terminal
quick-terminal-position = center
quick-terminal-size = 1280px,800px

###############################################################
## Keybinds

# general
keybind = global:super+shift+space=toggle_quick_terminal
keybind = super+shift+#=toggle_window_float_on_top
keybind = escape=unbind

# split
keybind = alt+left=goto_split:left
keybind = alt+down=goto_split:bottom
keybind = alt+up=goto_split:top
keybind = alt+right=goto_split:right
```

### Options utiles

| Option               | Description                                           |
| -------------------- | ----------------------------------------------------- |
| `font-family`        | Nom de la police (doit être installée sur le système) |
| `font-size`          | Taille en points                                      |
| `theme`              | Thème de couleurs (voir section suivante)             |
| `background-opacity` | Transparence de fond (0.0 à 1.0)                      |
| `window-padding-x/y` | Marges internes de la fenêtre                         |
| `scrollback-limit`   | Nombre de lignes conservées dans le buffer            |
| `shell-integration`  | Intégration shell pour des fonctionnalités avancées   |
| `window-save-state`  | Restaure l'état de la fenêtre au redémarrage          |

Pour voir toutes les options disponibles, consultez la [documentation officielle](https://ghostty.org/docs/config/reference).

### Quick Terminal (terminal déroulant)

L'une des fonctionnalités les plus pratiques de Ghostty sur Mac : un terminal "dropdown" qui peut être appelé de n'importe où via le raccourci **`Cmd+Shift+Space`**.

> [!IMPORTANT]
> Le Quick Terminal nécessite une permission d'accessibilité. Il faut se rendre dans **Réglages Système > Confidentialité et sécurité > Accessibilité** et autoriser Ghostty

## Thèmes et apparence

Ghostty embarque de nombreux thèmes directement, dont les incontournables Catppuccin, Tokyo Night, Dracula, Gruvbox et Solarized.

Pour lister tous les thèmes disponibles :

```bash
ghostty +list-themes
```

### Thèmes clair/sombre adaptatifs

Ghostty supporte les thèmes adaptatifs selon le mode système macOS :

```ini
theme = dark:Catppuccin Mocha,light:Catppuccin Latte
```

## Raccourcis clavier essentiels

Ghostty suit les conventions macOS. Voici les raccourcis les plus utiles :

### Fenêtres et onglets

| Raccourci               | Action                               |
| ----------------------- | ------------------------------------ |
| `Cmd + T`               | Nouvel onglet                        |
| `Cmd + W`               | Fermer l'onglet / le panneau courant |
| `Cmd + N`               | Nouvelle fenêtre                     |
| `Cmd + 1`, `Cmd + 2`…   | Naviguer entre les onglets           |
| `Cmd + Shift + {` / `}` | Onglet précédent / suivant           |

### Splits (panneaux)

| Raccourci               | Action                                     |
| ----------------------- | ------------------------------------------ |
| `Cmd + D`               | Diviser à droite                           |
| `Cmd + Shift + D`       | Diviser en bas                             |
| `Cmd + Shift + [` / `]` | Naviguer entre les panneaux                |
| `Cmd + Shift + Entrée`  | Agrandir/réduire le panneau courant (zoom) |
| `Cmd + Entrée`          | Plein écran                                |

### Divers

| Raccourci         | Action                  |
| ----------------- | ----------------------- |
| `Cmd + ,`         | Ouvrir la configuration |
| `Cmd + Shift + P` | Palette de commandes    |

Pour voir tous les raccourcis actifs :

```bash
ghostty list-keybinds
```
