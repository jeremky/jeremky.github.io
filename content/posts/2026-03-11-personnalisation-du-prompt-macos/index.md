---
title: "Personnalisation du prompt MacOS"
slug: personnalisation-du-prompt-macos
date: 2026-03-11T20:33:30+01:00
useRelativeCover: true
cover: cover.webp
author: JeremKy
tags:
  - macos
categories:
  - Tutos
toc: true
draft: false
---

J'avais écrit [un article](/posts/personnalisation-du-prompt-linux/) afin de personnaliser votre prompt Linux fonctionnant avec bash. Cette fois-ci, nous allons nous attaquer à MacOS, qui fonctionne non pas avec bash, mais avec Zsh.

Zsh (Z Shell) est un shell Unix moderne qui améliore considérablement bash. Créé en 1990, il offre une meilleure interactivité avec son auto-complétion avancée, ses thèmes élaborés et sa flexibilité de configuration. Contrairement à bash, Zsh permet une personnalisation plus intuitive du prompt et intègre nativement des fonctionnalités comme l'historique partagé entre sessions ou la navigation améliorée. Depuis macOS Catalina (2019), Zsh est le shell par défaut d'Apple, remplaçant bash qui n'est plus maintenu activement sur la plateforme.

> Il existe des solutions clé en main, comme [Oh My ZSH](https://ohmyz.sh/), mais l'idée est d'avoir une configuration la plus légère et optimisée possible

## Explication

Au démarrage d'une session shell, différents fichiers se chargent automatiquement. Cela permet de charger les configurations nécessaires au fonctionnement du prompt, comme son apparence, les variables d'environnement...

Contrairement à bash, le fichier chargé automatiquement est nommé `.zshrc`.

## Fichier .zshrc

Le fichier `.zshrc` n'existe pas par défaut. Zsh est chargé sans aucune personnalisation. Il va donc falloir le construire de 0. Comme base de départ, je vous partage le mien :

```bash
###############################################################
## zshrc

# Définir des séquences de couleur
RESET="%{$(tput sgr0)%}"        # Réinitialiser les couleurs
BOLD="%{$(tput bold)%}"         # Gras
RED="%{$(tput setaf 1)%}"       # Rouge
GREEN="%{$(tput setaf 2)%}"     # Vert
YELLOW="%{$(tput setaf 3)%}"    # Jaune
BLUE="%{$(tput setaf 4)%}"      # Bleu
MAGENTA="%{$(tput setaf 5)%}"   # Magenta
CYAN="%{$(tput setaf 6)%}"      # Cyan
WHITE="%{$(tput setaf 7)%}"     # Blanc

# Définir un prompt similaire à celui de Bash
PROMPT="${BOLD}${CYAN}%n@%m${RESET}:${BLUE}%~${RESET}$ "

# Options Zsh
setopt AUTO_CD                # Permet de naviguer dans un dossier sans 'cd'
setopt HIST_IGNORE_DUPS       # Ignore les doublons dans l'historique
setopt HIST_FIND_NO_DUPS      # Ignore les doublons lors de la recherche
setopt SHARE_HISTORY          # Partage l'historique entre les sessions
setopt INC_APPEND_HISTORY     # Ajoute immédiatement à l'historique

# Activer l'auto-complétion et désactiver la sensibilité à la casse
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Historique
HISTSIZE=1000                 # Nombre de commandes à garder en mémoire
SAVEHIST=1000                 # Nombre de commandes à enregistrer dans le fichier
HISTFILE="$HOME/.zsh_history" # Emplacement du fichier d'historique

# Configuration des couleurs pour 'ls'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Ajout de l'auto suggestion de zsh
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Ajout du surlignement avec le thème Catppuccin Macchiato
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source ~/.config/zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh
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

```bash
###############################################################
## zsh_aliases

# Variables
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8
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
alias md5='md5sum <<<'                                # Facilite l'utilisation de la commande md5
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

# fzf : recherche avancée avec thème Catppuccin Macchiato
if [[ -f /opt/homebrew/bin/fzf ]]; then
  source <(fzf --zsh)
  export FZF_DEFAULT_OPTS=" \
    --color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
    --color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
    --color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
    --color=selected-bg:#494D64 \
    --color=border:#6E738D,label:#CAD3F5"
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
| ifconfig | Utilise le programme ip (ifconfig n'existe plus sous Debian)     |
| md5      | Suivi d'une chaîne, pour connaître rapidement un md5             |
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

## Petit bonus : les aliases de scripts

Si vous avez quelques scripts, et que vous voulez y accéder depuis n'importe où facilement, vous pouvez ajouter ceci à la fin de votre fichier `.zsh_aliases` :

```bash
## Scripts
scripts=/chemin/vers/vos/scripts
if [[ -d $scripts ]]; then
  for i in $(ls $scripts) ; do
    if [[ -f $scripts/$i/$i.sh ]]; then
      alias $i=''$scripts'/'$i'/'$i'.sh'
    fi
  done
fi
```

Via ce petit bloc, un alias sera automatiquement créé pour chaque script qu'il trouvera dans un sous dossier qui porte le même nom. Par exemple, si un script nommé `test.sh` se trouve dans `/chemin/vers/vos/scripts/test`, un alias test sera créé.

## Conclusion

Avec ces 2 fichiers, vous avez déjà une base solide pour considérablement améliorer l'usage du terminal sous MacOS. Dans un prochain article, je vous présenterai comment utiliser Brew, un gestionnaire de paquets similaire à apt sous Debian.
