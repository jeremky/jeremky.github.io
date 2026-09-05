---
title: "Personnalisation de Bash"
slug: personnalisation-de-bash
weight: 1
contextMenu: true
toc: true
tags:
  - linux
draft: false
lastmod: 2026-09-05
---

Le shell Linux sert d'interface entre l'utilisateur et le système d'exploitation. Différents shells existent, comme bash, zsh, fish... Mais **bash** étant par défaut sur la plupart des distributions Linux, c'est sur ce dernier que je vais me focaliser.

## Explication

Au démarrage d'une session shell, différents fichiers se chargent automatiquement. Cela permet de charger les configurations nécessaires au fonctionnement du prompt, comme son apparence, les variables d'environnement...

Dans le home directory, se trouvent des fichiers cachés contenant ces informations :

- le fichier `.profile`, pour déterminer l'emplacement des binaires/commandes que l'on utilise, et le shell qui est utilisé (dans notre cas, bash)
- le fichier `.bashrc`, pour configurer bash (l'apparence du prompt, la longueur de l'historique des commandes, le chargement des complétions de commandes...)

## Fichier .bashrc

```bash {filename="~/.bashrc"}
# ─── .bashrc ─────────────────────────────────────────────────────────────

# if not interactive
case $- in
  *i*) ;;
  *) return ;;
esac

# global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# history
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend

# options
shopt -s autocd
shopt -s checkwinsize
shopt -s globstar

# colors
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# aliases
[[ -f ~/.bash_aliases ]] && . "$HOME/.bash_aliases"

# solus
[[ -f /usr/share/defaults/etc/profile ]] && source /usr/share/defaults/etc/profile

# prompt
case "$TERM" in
  xterm* | rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
  *) ;;
esac

# completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
```

## Fichier .bash_aliases

Le fichier `.bashrc` est préconfiguré pour charger un fichier personnalisé, appelé `.bash_aliases`. C'est ce dernier que nous allons créer et y ajouter nos personnalisations, notamment les aliases, qui permettent de se créer des "raccourcis" de commande, ou des fonctions. Le fichier est lu comme un script, il est donc possible d'y placer des conditions, ou des boucles.

Là encore, le plus simple, c'est que je vous partage le fichier que j'utilise.
Il est utilisable aussi bien pour votre user que pour root. Attention dans ce cas, le fichier ne se charge pas par défaut. Il faut ajouter dans le fichier `.bashrc` de root les lignes suivantes :

```bash
# aliases
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
```

Mon fichier `.bash_aliases` se divise en plusieurs parties :

- Une coloration spécifique pour certains fichiers/dossiers cachés dans les listings (`LS_COLORS`)
- Un paramètre pour ignorer la casse lors de la saisie (remplace automatiquement les caractères concernés lors d'une tabulation)
- La définition de certaines variables d'environnement (langue, éditeur par défaut)
- La gestion de sudo (pour la suite du fichier, et pour faire `su` au lieu de `sudo -s` pour passer root)
- La liste des aliases de base que j'utilise
- Des aliases supplémentaires pour des applications spécifiques, chargés uniquement si les applications sont installées
- Quelques fonctions, dans le cas où un simple alias est trop limitant
- Une transformation automatique des scripts présents dans `~/scripts` en aliases

Vous pouvez le récupérer directement sur github en suivant [ce lien](https://github.com/jeremky/envbackup/blob/main/dotfiles/debian/.bash_aliases).

Le contenu du fichier :

```bash {filename="~/.bash_aliases"}
# ─── .bash_aliases ───────────────────────────────────────────────────────

# ls colors
hidden=".gitignore .history .old"
for file in $hidden; do
  export LS_COLORS="$LS_COLORS:*$file=00;90"
done

# options
if [[ $- == *i* ]]; then
  bind 'set colored-stats on'          # Couleurs lors de la complétion
  bind 'set completion-ignore-case on' # Ignorer la casse lors de la complétion
  bind 'set show-all-if-unmodified on' # Affiche les correspondances immédiatement
fi

# prompt
if [[ "$EUID" -eq 0 ]]; then
  PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
fi

# variables
export LANG=fr_FR.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG
export EDITOR=vim
export VISUAL=$EDITOR

# ─── aliases ─────────────────────────────────────────────────────────────

alias ls='ls --color=auto'                               # Ajoute la couleur
alias l='ls -lh'                                         # Liste détaillée
alias la='ls -lhA'                                       # Liste avec les fichiers cachés
alias lr='ls -lLhR'                                      # Liste en récursif
alias lra='ls -lhRA'                                     # Liste en récursif avec les fichiers cachés
alias lrt='ls -lLhrt'                                    # Liste par date
alias lrta='ls -lLhrtA'                                  # Liste par date avec les fichiers cachés
alias dus='du -sh * | sort -hr'                          # Tri par taille
alias grep='grep -i --color=auto'                        # Grep sans sensibilité à la casse
alias zgrep='zgrep -i --color=auto'                      # Grep dans les fichiers compressés
alias psp='ps -eaf | grep -v grep | grep'                # Chercher un process (psp <nom>)
alias iostat='iostat -m --human'                         # iostat lisible
alias ifc='ip -br -c addr | grep -vw lo'                 # Adresses IP (ifconfig obsolète)
alias ssp='ss -tunlH | grep'                             # Chercher un port (ssp <port>)
alias pubip='curl -s -4 https://ipecho.net/plain ; echo' # IP publique
alias df='df -h -x tmpfs -x devtmpfs -x overlay'         # df sans montages inutiles
alias halt='sudo halt -p'                                # Arrêt système
alias reboot='sudo reboot'                               # Redémarrage

# sudo
[[ "$EUID" -ne 0 ]] && alias root='sudo -s'

# ssh
alias genkey='ssh-keygen -t ed25519 -a 100'        # Clé ed25519
alias genkeyrsa='ssh-keygen -t rsa -b 4096 -a 100' # Clé RSA

# ─── applications facultatives ───────────────────────────────────────────

# apt : gestionnaire de paquets deb
if command -v apt &>/dev/null; then
  alias apt='sudo apt'
  alias upgrade='sudo apt update && sudo apt full-upgrade && sudo apt -y autoremove'
fi

# btop / htop : top amélioré
if command -v btop &>/dev/null; then
  alias top='btop'
elif command -v htop &>/dev/null; then
  alias top='htop'
fi

# colordiff : diff avec couleur
command -v colordiff &>/dev/null && alias diff='colordiff'

# dnf : gestionnaire de paquets rpm
if command -v dnf &>/dev/null; then
  alias dnf='sudo dnf'
  alias upgrade='sudo dnf -y upgrade && sudo dnf -y autoremove'
fi

# duf : df amélioré
command -v duf &>/dev/null && alias duf='duf -hide special'

# dust : du amélioré
command -v dust &>/dev/null && alias dus='dust -rb'

# fd : find amélioré
if command -v fdfind &>/dev/null; then
  alias fd='fdfind -HI'
  export FZF_DEFAULT_COMMAND='fdfind -HI'
elif command -v fd &>/dev/null; then
  alias fd='fd -HI'
  export FZF_DEFAULT_COMMAND='fd -HI'
fi

# fzf : recherche avancée avec thème Catppuccin Mocha
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash)"
  export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A \
    --color=border:#6C7086,label:#CDD6F4"
fi

# icdiff : diff amélioré
command -v icdiff &>/dev/null && alias diff='icdiff'

# ncdu : équivalent à TreeSize
command -v ncdu &>/dev/null && alias ncdu='ncdu --color dark'

# procs : ps amélioré
command -v procs &>/dev/null && alias psp='procs'

# rg : plus performant que grep
command -v rg &>/dev/null && alias rg='rg -i --no-ignore'

# tmux : émulateur de terminal
if command -v tmux &>/dev/null; then
  alias tm='tmux attach || tmux new'
  alias tmr='tmux source-file ~/.config/tmux/tmux.conf'
fi

# tty-clock : horloge en CLI
command -v tty-clock &>/dev/null && alias clock='tty-clock -c -f %d/%m/%Y'

# ufw : firewall simplifié
if command -v ufw &>/dev/null; then
  alias ufw='sudo ufw'
  alias ufws='sudo ufw status numbered'
fi

# vim : vi amélioré
command -v vim &>/dev/null && alias vi='vim -O'

# zoxide : cd amélioré
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# ─── fonctions ──────────────────────────────────────────────────────────

# cleanlog : nettoyer les logs systemd
cleanlog() { [[ -n "$1" ]] && sudo journalctl --vacuum-time="${1}"d; }

# cpsave : copier un fichier ou dossier avec suffixe .old
cpsave() { cp -Rp "$1" "${1%/}.old"; }

# md5 : MD5 d'une chaîne
md5() { printf '%s' "$1" | md5sum | cut -d' ' -f1; }

# tarc : créer une archive tar.gz
tarc() { for file in "$@"; do tar czvf "${file%/}.tar.gz" "$file"; done; }

# tarx : décompresser une archive tar
tarx() { for file in "$@"; do tar xvf "$file"; done; }

# diskbench : tester la vitesse d'écriture disque
diskbench() {
  dd if=/dev/zero of=testfile bs=64M count=16 oflag=direct status=progress
  rm testfile
}

# webi : gestionnaire de paquets
webinstall() {
  curl -sS https://webi.sh/webi | sh
  source "$HOME/.config/envman/PATH.env"
}

# zipd : créer une archive zip par dossier/fichier donné
zipd() { for file in "$@"; do /usr/bin/zip -r "${file%/}.zip" "$file"; done; }

# ─── scripts ─────────────────────────────────────────────────────────────

# Transforme les scripts en alias
scripts=~/Documents/scripts
if [[ -d $scripts ]]; then
  for i in "$scripts"/*; do
    scr=${i##*/}
    # shellcheck disable=SC2139,SC2086
    [[ -f "$scripts/$scr/$scr.sh" ]] && alias $scr="$scripts/$scr/$scr.sh"
  done
fi
```

> [!NOTE]
> Le dernier bloc, `scripts`, parcourt le dossier `~/scripts` et crée automatiquement un alias pour chacun d'eux, du moment qu'il respecte la convention `<nom>/<nom>.sh`

Les aliases de base :

| Commande  | Description                                                          |
| --------- | -------------------------------------------------------------------- |
| l         | Liste les fichiers et les répertoires                                |
| la        | Même chose que l, dont les cachés                                    |
| lr        | Liste les fichiers et les répertoires en récursif                    |
| lra       | Même chose que lr, dont les cachés                                   |
| lrt       | Liste les fichiers et les répertoires dans l'ordre chronologique     |
| lrta      | Même chose que lrt, dont les cachés                                  |
| grep      | Ajoute la gestion de la couleur à grep                               |
| zgrep     | Même chose pour zgrep (grep dans les fichiers compressés)            |
| psp       | Suivi d'une chaîne, permet de rechercher rapidement un process       |
| iostat    | Commande iostat, mais plus lisible                                   |
| ifc       | Utilise le programme ip (ifconfig n'existe plus sous Debian)         |
| ss        | Remplaçant de netstat, mais épuré                                    |
| ssp       | Suivi d'une chaîne, permet de rechercher rapidement un port d'écoute |
| pubip     | Affiche rapidement l'IP publique de la machine                       |
| df        | Commande df, mais sans les volumes temporaires                       |
| halt      | Permet l'arrêt de la machine et non seulement le système             |
| reboot    | Ajoute sudo devant la commande reboot                                |
| root      | Permet de se connecter en root via sudo                              |
| apt       | Ajoute sudo et la commande `upgrade`                                 |
| genkey    | Génère une clé au format ed25519 (plus sécurisé que rsa)             |
| genkeyrsa | Génère une clé au format rsa en 4096 bits                            |

Les aliases actifs uniquement dans le cas où les applications sont installées :

| Commande | Description                                                                   |
| -------- | ----------------------------------------------------------------------------- |
| diff     | Remplace la commande par colordiff (icdiff prend le relais s'il est installé) |
| df       | [duf](/docs/linux/applications/duf/) est un df amélioré                       |
| d        | Lance dust, la commande `du` améliorée                                        |
| fd       | Outil équivalent à find mais bien plus simple à utiliser                      |
| fzf      | [fzf](/docs/linux/applications/fzf/) est un outil de recherche avancé         |
| top      | Remplace la commande top par btop (ou htop à défaut)                          |
| ncdu     | [ncdu](/docs/linux/applications/ncdu/) est un équivalent de Treesize          |
| psp      | Remplace la commande par procs, plus lisible et plus rapide                   |
| rg       | [ripgrep](/docs/linux/applications/ripgrep/) est un `grep` récursif lisible   |
| tm       | Attache la session tmux existante, ou en crée une nouvelle                    |
| tmr      | Recharge la configuration de tmux à chaud                                     |
| clock    | Lance tty-clock, un petit outil pour afficher l'heure                         |
| ufw      | [ufw](/docs/linux/applications/ufw/) est un Firewall accessible               |
| ufws     | Affiche le status de ufw, avec les règles numérotées                          |
| vi       | [vim](/docs/linux/applications/vim/) avec le split vertical actif             |
| z        | [zoxide](/docs/linux/applications/zoxide/) est un cd intélligent              |

Et enfin, les fonctions :

| Commande   | Description                                                                |
| ---------- | -------------------------------------------------------------------------- |
| cleanlog   | Supprimer les logs systemd en spécifiant le nombre de jours                |
| cpsave     | Créer une copie en .old d'un fichier ou d'un dossier spécifié              |
| gencert    | Générer un certificat en précisant le nom de domaine en paramètre          |
| md5        | Calculer le hash MD5 d'une chaîne de caractères                            |
| newuser    | Créer un compte de service (pas de home ni de mot de passe)                |
| tarc       | Créer un tar.gz d'un ou plusieurs fichiers ou dossiers passés en paramètre |
| tarx       | Pour extraire un ou plusieurs tar.gz passés en paramètre                   |
| diskbench  | Tester la vitesse du disque courant en créant un fichier                   |
| webinstall | Installe [webi](https://webinstall.dev/), un gestionnaire de paquets       |
| zipd       | Facilite l'utilisation de la commande zip (zip \<fichier>)                 |
