---
title: "Zed : un éditeur de code performant"
slug: zed-editeur-de-code-performant
date: 2026-04-30T19:25:48+02:00
useRelativeCover: true
cover: cover.webp
tags:
  - linux
  - macos
categories:
  - Tutos
toc: true
draft: false
---

A l'occasion de sa sortie en version 1.0, j'aimerais vous présenter un nouvel éditeur, qui, petit à petit, s'est imposé comme l'un des outils que j'utilise le plus au quotidien.

[Zed](https://zed.dev/) est un éditeur de code minimaliste, développé par les créateurs d'Atom après sa fermeture en 2022. Écrit entièrement en Rust, il a été conçu dès le départ pour offrir des performances élevées, une intégration de l'IA et une collaboration en temps réel. Disponible sur macOS et Linux (et plus récemment Windows), il se positionne comme une alternative sérieuse aux éditeurs traditionnels comme VS Code.

Ce qui m'a attiré vers Zed, c'est avant tout sa légèreté, sa modularité, et son mode Vim intégré nativement.

{{< image src="bash.webp" style="border-radius: 8px;" >}}

## Avantages et inconvénients

### Points forts

- **Performance** : écrit en Rust et rendu via le GPU, Zed est probablement l'éditeur le plus réactif du marché. Le démarrage est quasi-instantané, même sur de gros projets, et la latence de frappe est imperceptible.
- **Mode Vim intégré** : le mode Vim est natif, sans extension. Il supporte les text objects, les marks, et s'intègre naturellement avec le reste de l'éditeur.
- **IA native** : Zed intègre nativement plusieurs modèles (Claude, GPT, Gemini, Ollama…), aussi bien pour la complétion que pour un agent capable d'intervenir directement dans le code. La création d’un compte vous permet de profiter d’une complétion, dont 2000 mensuelles sont offertes avec un compte gratuit
- **Configuration en JSON** : tous les réglages se font dans un fichier texte, versionnable et facilement reproductible d'une machine à l'autre.
- **Interface épurée** : l'interface est minimaliste et ne distrait pas du code. Pas de menus superflus, tout est accessible via la palette de commandes.

### Limites

- **Écosystème d'extensions** : avec un peu plus de 500 extensions disponibles, le catalogue reste loin de celui de VS Code. Certains langages ou outils spécifiques peuvent manquer.
- **Debugger** : intégré depuis 2025, mais encore limité par rapport à VS Code sur des fonctionnalités avancées comme les watch windows ou les data breakpoints.
- **Modèle freemium** : certaines fonctionnalités IA (notamment la complétion prédictive avancée) sont limitées en nombre d'utilisations mensuelles sans abonnement.
- **Support Markdown** : basique. La prévisualisation est là, mais l'éditeur manque de fonctionnalités pour les longues sessions d'écriture.

{{< image src="markdown.webp" style="border-radius: 8px;" >}}

## Installation

### macOS

La méthode la plus simple reste d'utiliser brew. Un article [disponible ici](/posts/2026-03-21-homebrew-gestionnaire-dapplications-pour-macos) a été rédigé à son sujet. Une fois brew installé, lancez la commande suivante :

```bash
brew install zed
```

Si vous ne voulez installer Homebrew et préférez une méthode d’installation traditionnelle, vous pouvez récupérer le fichier `dmg` en suivant [ce lien](https://zed.dev/download-success?asset=Zed-aarch64.dmg&version=0.233.10&channel=stable)

### Linux

Depuis un terminal, assurez-vous d'avoir curl installé. Si ce n'est pas le cas, sur un système Debian :

```bash
sudo apt install curl
```

Puis lancez la commande suivante :

```bash
curl -f https://zed.dev/install.sh | sh
```

### Windows

Vous pouvez vous rendre sur la page [zed.dev](https://zed.dev/download), ou directement le télécharger depuis [ce lien](https://zed.dev/api/releases/stable/latest/Zed-x86_64.exe).

## Configuration

Zed dispose désormais d'une interface de configuration. Mais il est également possible de modifier directement les configurations via différents fichiers :

- les paramètres globaux
- les keymaps (raccourcis clavier)
- les snippets (des alias pour appeler des morceaux de texte/code)

Je vous recommande de consulter la [documentation officielle](https://zed.dev/docs/remote-development?highlight=settings#zed-settings).

> A noter que les fichiers de configuration que je vous partage sont spécifiques à mon usage. Beaucoup d'éléments ont été désactivés ou déplacés, ce qui peut rendre l'expérience très différente des paramètres définis par défaut. Je vous suggère donc de construire votre fichier de configuration en prenant le temps de tester les paramètres un par un

### Paramètres généraux (settings.json)

```json
// Zed settings

{
  // General
  "auto_update": true,
  "telemetry": {
    "metrics": false,
    "diagnostics": false,
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
  "agent": {
    "sidebar_side": "right",
    "dock": "right",
    "enabled": false,
  },
  "edit_predictions": {
    "mode": "eager",
    "provider": "zed",
  },

  // Interface
  "title_bar": {
    "show_sign_in": true,
    "show_branch_name": false,
  },
  "ui_font_size": 16.0,
  //"ui_font_family": "JetBrains Mono NL",
  "theme": {
    "mode": "system",
    "light": "Catppuccin Latte",
    "dark": "Catppuccin Mocha",
  },
  "icon_theme": {
    "mode": "system",
    "light": "Catppuccin Latte",
    "dark": "Catppuccin Mocha",
  },

  // Panels
  "project_panel": {
    "dock": "left",
    "hide_hidden": false,
    "hide_root": true,
    "scrollbar": { "horizontal_scroll": false },
  },
  "debugger": { "button": false },
  "collaboration_panel": { "dock": "left", "button": false },
  "git_panel": { "dock": "left", "button": false },
  "outline_panel": { "dock": "left", "button": false },

  // Editor
  "autosave": {
    "after_delay": {
      "milliseconds": 1000,
    },
  },
  "base_keymap": "VSCode",
  "vim_mode": false,
  "vim": {
    "use_system_clipboard": "never",
    "use_smartcase_find": true,
  },
  //"buffer_font_family": "JetBrains Mono NL",
  "buffer_font_size": 16,
  "extend_comment_on_newline": false,
  "snippet_sort_order": "top",
  "soft_wrap": "editor_width",
  "tab_size": 2,

  // Code
  "lsp": {
    "markdownlint": {
      "settings": {
        "MD013": false,
      },
    },
  },
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
  "file_types": {
    "TOML": ["cfg"],
  },

  // SSH
  "ssh_connections": [
    {
      "host": "jpi",
      "args": [],
      "projects": [
        {
          "paths": ["/home/jeremky"],
        },
      ],
    },
  ],

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

Le fichier a été organisé pour regrouper les paramètres :

- les paramètres généraux (désactivation de la télémétrie, configuration du terminal...)
- la configuration de l'IA (désactivation du panneau pour l'agent, choix du provider pour la complétion...)
- l'interface (La taille de police, le thème...)
- les panneaux (position de l'explorateur de fichiers, désactivation des panneaux que je n'utilise pas...)
- l'éditeur lui-même (sauvegarde automatique, taille des tabulations...)
- la gestion du code (gestion de l'outil `shfmt` pour bash, les tabulations forcées pour les fichier `Makefile`...)
- une section des connexions ssh (Zed peut se connecter nativement à un serveur ssh pour une édition directe)
- et enfin, l'installation automatique des extensions listées

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

Passant régulièrement de Zed version Mac et version Windows, j'ai tenté d'adapter des raccourcis pour les rendre communs aux 2 plateformes (`F1` pour exécuter une commande par exemple). Je me suis également basé sur certains raccourcis que j'utilise sous [Vim](/posts/2026-03-29-vim-configuration-finale).

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
  }
}
```

Ces snippets concernent surtout l'édition Markdown. Il suffit de saisir les préfixes spécifiés dans le fichier pour insérer les blocs concernés. Le curseur va se placer automatiquement sur chaque élément à modifier en appuyant sur `TAB`.

## Conclusion

Zed est encore un éditeur jeune, mais il tient ses promesses sur l'essentiel : la performance est au rendez-vous, l'interface ne distrait pas, et le mode Vim natif en fait un outil particulièrement agréable au quotidien. N'ayant pas besoin d'un environnement de développement complexe (je fais principalement des scripts bash), Zed a définitivement remplacé VS Code dans mon quotidien. L'écosystème d'extensions grandira avec le temps. En attendant, pour de l'édition de code ou de fichiers de configuration, il fait le travail sans se faire remarquer, ce qui est exactement ce qu'on lui demande.
