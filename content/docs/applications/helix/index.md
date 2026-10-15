---
title: "Helix"
slug: helix
contextMenu: true
weight: 50
toc: true
tags:
  - linux
  - macos
draft: false
lastmod: 2026-10-15
---

[Helix](https://helix-editor.com/) est un éditeur de texte modal fonctionnant dans le terminal, écrit en Rust. Inspiré de Vim et surtout de [Kakoune](https://kakoune.org/), il se distingue par son approche **sélection → action** : là où Vim attend une action puis un mouvement (`dw`), Helix sélectionne d'abord le texte (`w`) puis applique l'action (`d`). Le résultat de chaque commande est ainsi visible avant d'être exécuté.

Sa grande force est d'embarquer nativement ce qui nécessite habituellement de nombreux plugins sous [Vim](/docs/linux/applications/vim) : coloration syntaxique via Tree-sitter, support du LSP (autocomplétion, diagnostics, navigation dans le code), multi-curseurs, sélecteur de fichiers flou... Le tout sans aucune configuration préalable.

## Installation

### macOS

La méthode la plus simple reste d'utiliser brew. Un article [disponible ici](/docs/macos/utilisation-de-homebrew) a été rédigé à son sujet.

Une fois brew installé, lancez la commande suivante :

```bash
brew install helix
```

### Linux

Helix est disponible dans les dépôts de la plupart des distributions :

```bash
# Fedora
sudo dnf install helix

# Arch Linux
sudo pacman -S helix
```

> [!IMPORTANT]
> Selon les distributions, l'exécutable s'appelle `hx` ou `helix`. D'autres méthodes d'installation (AppImage, binaires précompilés...) sont détaillées dans la [documentation officielle](https://docs.helix-editor.com/package-managers.html)

Une fois installé, vérifiez le support des différents langages (serveurs LSP, formateurs...) avec la commande suivante :

```bash
hx --health
```

> [!NOTE]
> Helix embarque un tutoriel interactif, accessible via la commande `hx --tutor`. Je vous le recommande vivement pour prendre en main l'éditeur

## Les commandes de base

Si vous connaissez Vim, une bonne partie des raccourcis vous sera familière. Attention cependant, certains diffèrent du fait de la logique sélection → action :

| Commande        | Description                                                     |
| --------------- | --------------------------------------------------------------- |
| Esc             | Repasser en mode normal                                         |
| i / a           | Entrer en mode insertion avant / après la sélection             |
| v               | Entrer en mode sélection (extension de la sélection)            |
| w / b           | Sélectionner jusqu'au mot suivant / précédent                   |
| x               | Sélectionner la ligne courante (répéter pour étendre)           |
| %               | Sélectionner tout le fichier                                    |
| d               | Supprimer/couper la sélection                                   |
| c               | Supprimer la sélection et entrer en mode insertion              |
| y               | Copier la sélection                                             |
| p / P           | Coller après / avant la sélection                               |
| u / U           | Annuler / rétablir                                              |
| gg / ge         | Aller au début / à la fin du fichier                            |
| /               | Rechercher une chaîne (`n` / `N` pour suivant / précédent)      |
| s               | Sélectionner les occurrences d'une regex dans la sélection      |
| C               | Ajouter un curseur sur la ligne suivante                        |
| ,               | Conserver uniquement la sélection principale                    |
| Espace + f      | Ouvrir le sélecteur de fichiers                                 |
| Espace + /      | Rechercher dans tout le projet                                  |
| Espace + b      | Lister les buffers ouverts                                      |
| :w / :wq / :q!  | Enregistrer / enregistrer et quitter / quitter sans enregistrer |

> [!NOTE]
> En mode normal, appuyer sur `Espace` ou `g` affiche un menu listant toutes les commandes disponibles. Pratique pour découvrir l'éditeur sans avoir à retenir l'ensemble des raccourcis

## Configuration

La configuration de Helix s'effectue via 2 fichiers `toml` à créer dans le dossier `~/.config/helix` :

- `config.toml` : les paramètres de l'éditeur et les raccourcis clavier
- `languages.toml` : les paramètres spécifiques à chaque langage (formateurs, serveurs LSP...)

```bash
mkdir -p ~/.config/helix
touch ~/.config/helix/config.toml ~/.config/helix/languages.toml
```

> [!NOTE]
> Les fichiers de configuration que je vous partage sont spécifiques à mon usage. Je vous suggère de construire votre propre configuration en vous aidant de la [documentation officielle](https://docs.helix-editor.com/configuration.html)

### Paramètres généraux

```toml {filename="~/.config/helix/config.toml"}
theme = "catppuccin_mocha"

[editor]
default-yank-register = "+"
cursorline = true
true-color = true
color-modes = true
scrolloff = 4
bufferline = "multiple"
idle-timeout = 400

[editor.cursor-shape]
insert = "bar"
select = "underline"

[editor.indent-guides]
render = true

[editor.soft-wrap]
enable = true
wrap-indicator = ""

[editor.file-picker]
hidden = false

[editor.lsp]
enable = true

[keys.normal]
"del" = "delete_char_forward"
"D" = ["select_mode", "goto_line_end", "delete_selection"]
"G" = "goto_last_line"
"$" = "goto_line_end"
"0" = "goto_line_start"

"F2" = ":toggle mouse"
"F4" = "toggle_comments"
"F5" = ":format"
```

Ce fichier permet notamment :

- d'utiliser le thème [Catppuccin](/docs/linux/theme-catppuccin) (embarqué nativement dans Helix)
- d'utiliser le presse-papier système pour copier/coller (`default-yank-register = "+"`)
- de mettre en évidence la ligne courante et de colorer la barre de statut selon le mode actif
- d'adapter la forme du curseur en fonction du mode (barre en insertion, souligné en sélection)
- d'afficher les guides d'indentation et d'activer le retour à la ligne automatique
- d'afficher la barre des buffers dès que plusieurs fichiers sont ouverts
- d'afficher les fichiers cachés dans le sélecteur de fichiers

### Raccourcis clavier

La section `[keys.normal]` redéfinit certains raccourcis afin de retrouver des habitudes héritées de [Vim](/docs/linux/applications/vim) :

| Raccourci | Action                                              |
| --------- | --------------------------------------------------- |
| `Suppr`   | Supprimer le caractère sous le curseur              |
| `D`       | Supprimer jusqu'à la fin de la ligne                |
| `G`       | Aller à la fin du fichier                           |
| `$` / `0` | Aller à la fin / au début de la ligne               |
| `F2`      | Activer / désactiver la souris                      |
| `F4`      | Commenter / décommenter la sélection                |
| `F5`      | Formater le fichier                                 |

> [!NOTE]
> Les touches `F4` et `F5` reprennent les mêmes raccourcis que ceux définis pour [Zed](/docs/applications/zed), afin de conserver des habitudes communes entre les 2 éditeurs

### Langages

```toml {filename="~/.config/helix/languages.toml"}
[[language]]
name = "bash"
formatter = { command = "shfmt", args = ["-i", "2", "-ci", "-"] }
auto-format = true

[[language]]
name = "css"
formatter = { command = "deno", args = ["fmt", "-", "--ext", "css"] }
auto-format = true

[[language]]
name = "docker-compose"
formatter = { command = "deno", args = ["fmt", "--ext", "yaml", "-"] }
auto-format = true

[[language]]
name = "html"
formatter = { command = "deno", args = ["fmt", "--ext", "html", "-"] }
auto-format = true

[[language]]
name = "javascript"
formatter = { command = "deno", args = ["fmt", "-", "--ext", "js"] }
auto-format = true

[[language]]
name = "json"
formatter = { command = "deno", args = ["fmt", "-", "--ext", "json"] }
auto-format = true

[[language]]
name = "markdown"
formatter = { command = "deno", args = ["fmt", "--ext", "md", "-"] }
auto-format = true

[[language]]
name = "yaml"
formatter = { command = "deno", args = ["fmt", "--ext", "yaml", "-"] }
auto-format = true
```

Ce fichier définit un formateur pour chaque langage, appliqué automatiquement à chaque sauvegarde (`auto-format = true`) :

- `shfmt` pour les scripts bash, avec une indentation de 2 espaces
- `deno fmt` pour tous les autres langages (CSS, HTML, JavaScript, JSON, Markdown et YAML)

#### Dépendances

Pour que le formatage et la reconnaissance intelligente des scripts bash fonctionnent, il est nécessaire d'installer les outils correspondants. Avec [Homebrew](/docs/macos/utilisation-de-homebrew) :

```bash
brew install shfmt shellcheck deno bash-language-server
```

Une fois installés, la commande `hx --health bash` doit indiquer que le serveur LSP et le formateur sont bien détectés.
