---
title: "Zed : un éditeur de code haute performance"
slug: zed-editeur-code-haute-performance
date: 2026-04-15T19:00:06+02:00
useRelativeCover: true
cover: cover.webp
author: JeremKy
tags:
  - linux
  - macos
categories:
  - Tutos
toc: true
draft: true
---

Zed est un éditeur de code minimaliste, développé par les créateurs d'Atom après sa fermeture en 2022. Écrit entièrement en Rust, il a été conçu dès le départ pour offrir des performances natives, une intégration de l'IA et une collaboration en temps réel. Disponible sur macOS et Linux (et plus récemment Windows), il se positionne comme une alternative sérieuse aux éditeurs traditionnels comme VS Code.

Ce qui m'a attiré vers Zed, c'est avant tout sa légèreté et son mode Vim intégré nativement. Un éditeur moderne, rapide, avec les réflexes Vim : le meilleur des deux mondes.

## Avantages et inconvénients

### Points forts

- **Performance** : écrit en Rust et rendu via le GPU, Zed est probablement l'éditeur le plus réactif du marché. Le démarrage est quasi instantané, même sur de gros projets, et la latence de frappe est imperceptible.
- **Mode Vim intégré** : le mode Vim est natif, pas une extension. Il supporte les text objects, les marks, et s'intègre naturellement avec le reste de l'éditeur.
- **IA native** : Zed intègre nativement plusieurs modèles (Claude, GPT, Gemini, Ollama…), aussi bien pour la complétion que pour un agent capable d'intervenir directement dans le code.
- **Configuration en JSON** : tous les réglages se font dans un fichier texte, versionnable et facilement reproductible d'une machine à l'autre.
- **Interface épurée** : l'interface est minimaliste et ne distrait pas du code. Pas de menus superflus, tout est accessible via la palette de commandes.

### Limites

- **Écosystème d'extensions** : avec un peu plus de 500 extensions disponibles, le catalogue reste loin de celui de VS Code. Certains langages ou outils spécifiques peuvent manquer.
- **Debugger** : intégré depuis 2025, mais encore limité par rapport à VS Code sur des fonctionnalités avancées comme les watch windows ou les data breakpoints.
- **Modèle freemium** : certaines fonctionnalités IA (notamment la complétion prédictive avancée) sont limitées en nombre d'utilisations mensuelles sans abonnement.
- **Support Markdown** : basique. La prévisualisation est là, mais des raccourcis courants comme le gras via Ctrl+B ou le repli de sections sont absents.

## Installation

### macOS

```bash
brew install zed
```

### Linux

```bash
curl -f https://zed.dev/install.sh | sh
```

## Configuration

### Paramètres généraux (settings.json)

```json
// Zed settings

{
  // General
  "auto_update": false,
  "telemetry": {
    "metrics": false,
    "diagnostics": false,
  },
  "project_panel": {
    "hide_hidden": false,
    "hide_root": true,
    "scrollbar": {
      "horizontal_scroll": false,
    },
  },
  "session": {
    "trust_all_worktrees": true,
  },
  "terminal": {
    "copy_on_select": true,
    "working_directory": "current_file_directory",
  },

  // AI
  "disable_ai": false,
  "edit_predictions": {
    "mode": "eager",
    "provider": "zed",
  },
  "agent": {
    "enable_feedback": false,
    "enabled": true,
    "default_model": {
      "provider": "copilot_chat",
      "model": "claude-haiku-4.5",
      "enable_thinking": false,
    },
  },

  // Themes
  "theme": {
    "mode": "dark",
    "light": "Catppuccin Latte",
    "dark": "Catppuccin Macchiato",
  },
  "icon_theme": "Catppuccin Macchiato",

  // Interface
  "title_bar": { "show_sign_in": true },
  "ui_font_size": 16.0,
  "ui_font_family": "JetBrainsMono Nerd Font Mono",
  "tab_bar": { "show_nav_history_buttons": false },
  "preview_tabs": { "enabled": true },

  // Status Bar
  "collaboration_panel": { "button": false },
  "notification_panel": { "button": false },
  "outline_panel": { "button": false },
  "debugger": { "button": false },

  // Editor
  "base_keymap": "VSCode",
  "vim_mode": false,
  "vim": {
    "use_system_clipboard": "never",
    "use_smartcase_find": true,
  },
  "autosave": {
    "after_delay": {
      "milliseconds": 1000,
    },
  },
  "snippet_sort_order": "top",
  "buffer_font_family": "JetBrainsMono Nerd Font Mono",
  "buffer_font_size": 16,
  "buffer_font_features": { "calt": false },
  "soft_wrap": "editor_width",
  "extend_comment_on_newline": false,
  "tab_size": 2,

  // LSP
  "lsp": {
    "markdownlint": {
      "settings": {
        "MD013": false,
      },
    },
  },

  // Languages
  "languages": {
    "Make": {
      "hard_tabs": true,
    },
    "Shell Script": {
      "formatter": {
        "external": {
          "command": "shfmt",
          "arguments": ["-i", "2", "-ci", "-"],
        },
      },
    },
  },

    // Filetypes
  "file_types": {
    "Shell Script": ["cfg"],
  },

  // Extensions
  "auto_install_extensions": {
    "basher": true,
    "catppuccin": true,
    "catppuccin-icons": true,
    "codebook": true,
    "csv": true,
    "docker-compose": true,
    "git-firefly": true,
    "html": true,
    "make": true,
    "markdownlint": true,
    "scss": true,
    "sql": true,
    "ssh-config": true,
    "toml": true,
    "xml": true,
  },
}
```

### Raccourcis clavier (keymap.json)

```json
[
  {
    "context": "Editor",
    "bindings": {
      "f2": "workspace::ToggleVimMode",
      "f4": "editor::ToggleComments",
      "f5": "editor::Format",
    },
  },
  {
    "bindings": {
      "f1": "command_palette::Toggle",
      "f3": "project_panel::ToggleHideHidden",
    },
  },
]
```

### Snippets

```json
{
  "Code bloc": {
    "prefix": "code",
    "body": ["```${1:code}", "${2:}", "```", ""],
    "description": "Insérer un bloc de code"
  },
  "Image bloc": {
    "prefix": "img",
    "body": ["![${1:alt}](${2:})", ""],
    "description": "Insérer une image"
  },
  "URL bloc": {
    "prefix": "url",
    "body": ["[${1:text}](${2:})", ""],
    "description": "Insérer une URL"
  },

  "Hugo image shortcode": {
    "prefix": "blogimg",
    "body": [
      "{{< image src=\"${1:filename}.webp\" style=\"border-radius: 8px;\" >}}",
      ""
    ],
    "description": "Shortcode Hugo pour les images"
  }
}
```

## Utilisation

### Édition Markdown

<!-- Screenshot + description -->

### Scripts Bash

<!-- Screenshot + description -->

### Accès distant via SSH

<!-- Screenshot + description -->

## Conclusion

Zed est encore un éditeur jeune, mais il tient ses promesses sur l'essentiel : la performance est au rendez-vous, l'interface ne distrait pas, et le mode Vim natif en fait un outil particulièrement agréable au quotidien. L'écosystème d'extensions grandira avec le temps. En attendant, pour de l'édition de code ou de fichiers de configuration, il fait le travail sans se faire remarquer, ce qui est exactement ce qu'on lui demande.
