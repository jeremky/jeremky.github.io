---
title: "Personnalisation de Zsh"
slug: personnalisation-de-zsh
weight: 1
contextMenu: true
toc: true
tags:
  - macos
draft: false
lastmod: 2026-05-18
---

_[Le Z shell](https://fr.wikipedia.org/wiki/Z_Shell) ou zsh est un shell Unix qui peut être utilisé de façon interactive, à l'ouverture de la session ou en tant que puissant interpréteur de commande. zsh peut être vu comme un « Bourne shell » étendu avec beaucoup d'améliorations. Il reprend en plus la plupart des fonctions les plus pratiques de bash, ksh et tcsh. Zsh remplace bash dans macOS à partir de macOS Catalina 10.15._

> Il existe des solutions clé en main, comme [Oh My ZSH](https://ohmyz.sh/), mais l'idée est d'avoir une configuration la plus légère et optimisée possible

## Explication

Au démarrage d'une session shell, différents fichiers se chargent automatiquement. Cela permet de charger les configurations nécessaires au fonctionnement du prompt, comme son apparence, les variables d'environnement...

## Fichier .zshrc

Le fichier `.zshrc` n'existe pas par défaut. Zsh est chargé sans aucune personnalisation. Il va donc falloir le construire de 0. Comme base de départ, je vous partage le mien :

```bash {filename="~/.zshrc"}
###############################################################
## zshrc

# Définir des séquences de couleur
RESET="%{%b%f%}"            # Réinitialiser
BOLD="%{%B%}"               # Gras
RED="%{%F{red}%}"           # Rouge
GREEN="%{%F{green}%}"       # Vert
YELLOW="%{%F{yellow}%}"     # Jaune
BLUE="%{%F{blue}%}"         # Bleu
MAGENTA="%{%F{magenta}%}"   # Magenta
CYAN="%{%F{cyan}%}"         # Cyan
WHITE="%{%F{white}%}"       # Blanc

# Définir un prompt similaire à celui de Bash
PROMPT="${BOLD}${CYAN}%n@%m${RESET}:${BLUE}%~${RESET}$ "

# Options Zsh
setopt AUTO_CD                # Permet de naviguer dans un dossier sans 'cd'
setopt HIST_IGNORE_DUPS       # Ignore les doublons dans l'historique
setopt HIST_FIND_NO_DUPS      # Ignore les doublons lors de la recherche
setopt SHARE_HISTORY          # Partage l'historique entre les sessions
setopt INC_APPEND_HISTORY     # Ajoute immédiatement à l'historique

# Activer l'auto-complétion et désactiver la sensibilité à la casse
mkdir -p "$HOME/.local/share/zsh"
autoload -Uz compinit && compinit -u -d "$HOME/.local/share/zsh/zcompdump"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Déplacer le dossier de cache
zstyle ':completion:*' cache-path "$HOME/.local/share/zsh/zcompcache"

# Historique
HISTSIZE=10000                              # Nombre de commandes à garder en mémoire
SAVEHIST=10000                              # Nombre de commandes à enregistrer dans le fichier
HISTFILE="$HOME/.local/share/zsh/history"   # Emplacement du fichier d'historique

# Configuration des couleurs pour 'ls'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Ajout de l'auto suggestion de zsh
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Ajout du surlignement
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[path]=none
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]=none
  ZSH_HIGHLIGHT_STYLES[path_prefix]=none
  ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=none
  ZSH_HIGHLIGHT_STYLES[precommand]=none
fi

# Bind de touches
bindkey -e                        # Activation des bindings
bindkey "\e[H" beginning-of-line  # Binding pour la touche "Home"
bindkey "\e[F" end-of-line        # Binding pour la touche "End"

# Charge le fichier .zsh_aliases, si présent
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
```

> Chaque partie est suffisamment commentée pour vous permettre de comprendre les effets de chaque bloc

## Fichier .zsh_aliases

Afin de garder une cohérence avec le système Linux, nous allons créer un fichier `.zsh_aliases`. Ce fichier contiendra nos personnalisations, notamment les aliases, qui permettent de se créer des "raccourcis" de commande, ou des fonctions. Le fichier est lu comme un script, il est donc possible d'y placer des conditions, ou des boucles.

Mon fichier `.zsh_aliases` se divise en plusieurs parties :

- La définition de certaines variables d'environnement (langue, éditeur par défaut)
- Des paramètres spécifiques à brew si vous l'avez installé
- La liste des aliases de base que j'utilise
- Des aliases supplémentaires pour des applications spécifiques, chargés uniquement si les applications sont installées
- Quelques fonctions, dans le cas où un simple alias est trop limitant

Le contenu du fichier :

```bash {filename="~/.zsh_aliases"}
###############################################################
## zsh_aliases

# Variables
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8
export LESSHISTFILE=/dev/null
export EDITOR=vim

# Variables Brew
if [[ -f /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_NO_ANALYTICS=1
  alias upgrade='brew update && brew upgrade -g && brew cleanup'
fi

# Commandes
alias l='ls -lh'                                      # Liste détaillée
alias la='ls -lhA'                                    # Liste avec les fichiers cachés
alias lr='ls -lLhR'                                   # Liste en récursif
alias lra='ls -lhRA'                                  # Liste en récursif avec les fichiers cachés
alias lrt='ls -lLhrt'                                 # Liste par date
alias lrta='ls -lLhrtA'                               # Liste par date avec les fichiers cachés
alias grep='grep -i --color=auto'                     # Grep sans la sensibilité à la casse
alias zgrep='zgrep -i --color=auto'                   # Grep dans les fichiers compressés
alias psp='ps -eaf | grep -v grep | grep'             # Chercher un process (psp <nom process>)
alias genkey='ssh-keygen -t ed25519 -a 100'           # Générer une clé ed25519
alias ifconfig='ifconfig en0 && ifconfig en1'         # Afficher les adresses IP
alias pubip='curl -s -4 ipecho.net/plain ; echo'      # Afficher l'adresse IP publique
alias df='df -PlH'                                    # Commande df en filtrant les montages inutiles
alias rmds='find . -name '.DS_Store' -type f -delete' # Suppression recursive des fichiers ".DS_Store"
alias rmdot="find . -name '._*' -type f -delete"      # Suppression recursive des fichiers "._"
alias top='top -o cpu -U $(whoami)'                   # Commande top filtrée pour le user
alias vi='vim -nO'                                    # vim : vi amélioré avec ouverture multiple

###############################################################
## Applications facultatives

# colordiff : diff avec couleur
[[ -f /opt/homebrew/bin/colordiff ]] && alias diff='colordiff'

# duf : affiche les files systems
[[ -f /opt/homebrew/bin/duf ]] && alias df='duf -hide special'

# fzf : recherche avancée
if [[ -f /opt/homebrew/bin/fzf ]]; then
  source <(fzf --zsh)
fi

# ncdu : équivalent à TreeSize
[[ -f /opt/homebrew/bin/ncdu ]] && alias ncdu='ncdu --color dark'

# rg : plus performant que grep
[[ -f /opt/homebrew/bin/rg ]] && alias rg='rg -i'

# zoxide : cd amélioré
[[ -f /opt/homebrew/bin/zoxide ]] && eval "$(zoxide init zsh)"

###############################################################
## Fonctions

# cpsave : copie un fichier ou un dossier avec .old
cpsave() { cp -Rp "$1" "${1%/}.$(date +%Y%m%d).old" ;}

# tarc : créer une archive pour chaque fichier / dossier spécifié
tarc() { for file in "$@"; do tar czvf "${file%/}.tar.gz" -- "$file"; done ;}

# tarx : décompresse une archive spécifiée
tarx() { for file in "$@"; do tar xzvf -- "$file"; done ;}

# zip : commande zip plus conviviale
zip() { for file in "$@"; do /usr/bin/zip -r "${file%/}.zip" "$file" ; done ;}

# convweb : convertir les fichiers png en webp
convweb() { for file in "$@" ; do cwebp -q 100 "$file" -o "${file%.*}.webp" && rm -- "$file" ; done ;}
```

Les aliases de base :

| Commande | Description                                                      |
| -------- | ---------------------------------------------------------------- |
| l        | Liste les fichiers et les répertoires                            |
| la       | Même chose que l, dont les cachés                                |
| lr       | Liste les fichiers et les répertoires en récursif                |
| lra      | Même chose que lr, dont les cachés                               |
| lrt      | Liste les fichiers et les répertoires dans l'ordre chronologique |
| lrta     | Même chose que lrt, dont les cachés                              |
| grep     | Ajoute la gestion de la couleur à grep                           |
| zgrep    | Même chose pour zgrep (grep dans les fichiers compressés)        |
| psp      | Suivi d'une chaîne, permet de rechercher rapidement un process   |
| genkey   | Génère une clé au format ed25519 (plus sécurisé que rsa)         |
| ifconfig | Affiche les cartes ethernet et Wifi seulement                    |
| pubip    | Affiche rapidement l'IP publique de la machine                   |
| df       | Commande df, mais sans les volumes temporaires                   |
| rmds     | Suppression recursive des fichiers `.DS_Store`                   |
| rmdot    | Suppression recursive des fichiers `._`                          |
| top      | Commande top filtrée pour le user                                |
| vi       | vim : vi amélioré avec ouverture multiple                        |

Les aliases actifs uniquement dans le cas où les applications sont installées :

| Commande | Description                                                       |
| -------- | ----------------------------------------------------------------- |
| diff     | Remplace la commande par colordiff, pour une meilleure lisibilité |
| df       | Remplace la commande par duf, bien plus agréable visuellement     |
| fzf      | Outil de recherche avancé                                         |
| ncdu     | L'équivalent de l'outil Treesize sous Windows                     |
| rg       | Un grep récursif, bien plus lisible que le grep de base           |

Et enfin, les fonctions :

| Commande | Description                                                                |
| -------- | -------------------------------------------------------------------------- |
| cpsave   | Créer une copie en date.old d'un fichier ou d'un dossier spécifié          |
| tarc     | Créer un tar.gz d'un ou plusieurs fichiers ou dossiers passés en paramètre |
| tarx     | Pour extraire un ou plusieurs tar.gz passés en paramètre                   |
| zip      | Facilite l'utilisation de la commande zip (`zip <fichier>`)                |
| convweb  | Transforme une image passée en paramètre au format webp                    |
