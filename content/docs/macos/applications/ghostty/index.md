---
title: "Ghostty"
slug: ghostty
contextMenu: true
weight: 10
toc: true
tags:
  - linux
draft: true
lastmod: 2026-05-23
---

Ghostty est un émulateur de terminal moderne, rapide et natif sur macOS. Créé par Mitchell Hashimoto (co-fondateur de HashiCorp, l'auteur de Terraform et Vagrant), il est sorti en open source fin 2024 et a rapidement conquis la communauté des développeurs. Voici comment l'installer, le configurer et en tirer le meilleur parti.

## Pourquoi Ghostty ?

La plupart des terminaux populaires font un compromis entre performance, fonctionnalités et intégration native. Ghostty refuse ce compromis.

Là où des terminaux comme Hyper ou Tabby s'appuient sur Electron (et donc un moteur Chromium complet), **Ghostty utilise nativement AppKit et SwiftUI sur macOS**. Résultat : une empreinte mémoire faible, un rendu GPU fluide via Metal, et un comportement conforme aux conventions macOS (drag-and-drop natif, raccourcis système, Quick Look, Secure Input API...).

Ses principaux atouts :

- **Rendu GPU** : scrolling fluide même sur de gros fichiers de logs
- **Natif macOS** : s'intègre comme une vraie application Mac
- **Zéro télémétrie** : aucune donnée envoyée nulle part
- **Prêt à l'emploi** : des défauts bien pensés, pas besoin de tout configurer dès le départ
- **Protocole Kitty Graphics** : affichage d'images dans le terminal

## Installation

La façon la plus simple d'installer Ghostty sur Mac est via Homebrew. S'il n'est pas encore installé sur votre machine, je vous recommande de vous rendre sur [cette page](/docs/macos/utilisation-de-homebrew).

> **Alternative** : si vous préférez télécharger le `.dmg`, il est [disponible ici](https://ghostty.org/download)

## Configuration

Ghostty ne dispose pas d'interface de configuration. Tout se fait via un fichier texte. Pour respecter le nouvel emplacement, je vous recommande de créer le fichier au préalable :

```bash
mkdir -p ~/.config/ghostty
touch ~/.config/ghostty/config
```

Vous pourrez ensuite l'ouvrir directement depuis Ghossty, via le raccourci **`Cmd + ,`**.

### Exemple de configuration de base

```ini
###############################################################
## Ghostty

# general
auto-update = off
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
theme = dark:Catppuccin Mocha,light:Catppuccin Latte
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

Pour voir toutes les options disponibles, consulte la [référence officielle](https://ghostty.org/docs/config/reference).

### Quick Terminal (terminal déroulant)

L'une des fonctionnalités les plus pratiques de Ghostty sur Mac : un terminal "dropdown" qui s'anime depuis la barre de menu, sans interrompre ton travail.

Pour l'activer, ajoute dans ta config :

```ini
keybind = global:cmd+grave_accent=toggle_quick_terminal
```

> [!IMPORTANT]
> Le Quick Terminal nécessite une permission d'accessibilité. Va dans **Réglages Système > Confidentialité et sécurité > Accessibilité** et autorise Ghostty

## Thèmes et apparence

Ghostty embarque de nombreux thèmes directement, dont les incontournables Catppuccin, Tokyo Night, Dracula, Gruvbox et Solarized.

Pour lister tous les thèmes disponibles :

```bash
ghostty +list-themes
```

Pour prévisualiser un thème en direct, tu peux le changer temporairement dans ta config, puis recharger Ghostty.

### Thèmes clair/sombre adaptatifs

Ghostty supporte les thèmes adaptatifs selon le mode système macOS :

```ini
theme = light:catppuccin-latte,dark:catppuccin-mocha
```

### Polices

Pour lister les polices reconnues par Ghostty :

```bash
ghostty +list-fonts
```

Les polices Nerd Font sont recommandées pour un bon rendu des icônes (notamment avec des prompts comme Starship ou Oh My Zsh). Par exemple, installe Meslo LG :

```bash
brew install font-meslo-lg-nerd-font
```

Puis dans ta config :

```ini
font-family = MesloLGS Nerd Font Mono
```

---

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

### Personnaliser les raccourcis

La syntaxe est simple dans le fichier de config :

```ini
keybind = trigger=action
```

Exemples :

```ini
# Remapper Ctrl+D pour fermer un panneau
keybind = ctrl+d=close_surface

# Ouvrir un nouvel onglet avec Ctrl+T
keybind = ctrl+t=new_tab
```

Pour voir tous les raccourcis actifs :

```bash
ghostty list-keybinds
```
