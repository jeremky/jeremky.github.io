---
title: Personnalisation du prompt Linux
date: 2024-05-02T17:13:12Z
useRelativeCover: true
cover: cover.webp
tags:
  - linux
categories:
  - Tutos
toc: true
draft: false
---

Après avoir partagé mes configurations de Vi, c'est au tour de ma personnalisation des prompts Linux, le shell. Il sert d'interface entre l'utilisateur et le système d'exploitation. Différents shells existent, comme bash, zsh, fish... Mais bash étant par défaut sur la plupart des distributions Linux, c'est sur ce dernier que je vais me focaliser.

## Explication

Au démarrage d'une session shell, différents fichiers se chargent automatiquement. Cela permet de charger les configurations nécessaires au fonctionnement du prompt, comme son apparence, les variables d'environnement...

Dans le home directory, se trouvent des fichiers cachés contenant ces informations :

- le fichier `.profile`, pour déterminer l'emplacement des binaires/commandes que l'on utilise, et le shell qui est utilisé (dans notre cas, bash)
- le fichier `.bashrc`, pour configurer bash (l'apparence du prompt, la longueur de l'historique des commandes, le chargement des complétions de commandes...)

## Fichier .bash_aliases

Le fichier `.bashrc` est préconfiguré pour charger un fichier personnalisé, appelé `.bash_aliases`. C'est ce dernier que nous allons créer et y ajouter nos personnalisations, notamment les aliases, qui permettent de se créer des "raccourcis" de commande, ou des fonctions. Le fichier est lu comme un script, il est donc possible d'y placer des conditions, ou des boucles.

Là encore, le plus simple, c'est que je vous partage le fichier que j'utilise. Il est utilisable aussi bien pour votre user que pour root. Attention dans ce cas, le fichier ne se charge pas par défaut. Il faut ajouter dans le fichier `.bashrc` de root les lignes suivantes :

```bash
# Alias definitions.
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi
```

Mon fichier `.bash_aliases` se divise en plusieurs parties :

- La définition de certaines variables d'environnement (langue, éditeur par défaut)
- Un paramètre pour ignorer la casse lors de la saisie (remplace automatiquement les caractères concernés lors d'une tabulation)
- La gestion de sudo (pour la suite du fichier, et pour faire `su` au lieu de `sudo -s` pour passer root)
- La liste des aliases de base que j'utilise
- Des aliases supplémentaires pour des applications spécifiques, chargés uniquement si les applications sont installées
- Quelques fonctions, dans le cas où un simple alias est trop limitant

Vous pouvez le récupérer directement sur github en suivant [ce lien](https://github.com/jeremky/envbackup/blob/main/dotfiles/.bash_aliases).

Le contenu du fichier :

```bash
##################################################################
## Bash

# Affichage
if [[ $USER = root ]]; then
PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
fi

# Variables
export LANG=fr_FR.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG
export EDITOR=vim
export VISUAL=$EDITOR
export TMOUT=1800

# Tweaks divers
bind 'set colored-stats on'              # Affiche les couleurs lors de la complétion
bind 'set completion-ignore-case on'     # Ignorer la casse lors de la complétion
bind 'set mark-symlinked-directories on' # Meilleure gestion des liens symboliques
bind 'set show-all-if-unmodified on'     # Affiche les correspondances possibles immédiatement

# Sudo : utiliser la commande root pour...passer root :)
if [[ -f /usr/bin/sudo ]] && [[ $USER != root ]]; then
alias root='sudo -i'
alias su='sudo -s'
sudo=sudo
fi

##################################################################
## Commandes

# Prompt
alias ls='ls --color=auto'                       # Ajoute la couleur
alias l='ls -lh'                                 # Liste détaillée
alias la='ls -lhA'                               # Liste avec les fichiers cachés
alias lr='ls -lLhR'                              # Liste en récursif
alias lra='ls -lhRA'                             # Liste en récursif avec les fichiers cachés
alias lrt='ls -lLhrt'                            # Liste par date
alias lrta='ls -lLhrtA'                          # Liste par date avec les fichiers cachés
alias grep='grep -i --color=auto'                # Grep sans la sensibilité à la casse
alias zgrep='zgrep -i --color=auto'              # Grep dans les fichiers compressés
alias psp='ps -eaf | grep -v grep | grep'        # Chercher un process (psp <nom process>)
alias iostat='iostat -m --human'                 # Commande iostat lisible
alias ifconfig='ip -br -c addr | grep -v lo'     # Afficher les adresses IP (ifconfig n'existe plus)
alias ss='ss -tunlH'                             # Afficher les ports d'écoute
alias ssp='ss | grep'                            # Chercher un port (ssp <port>)
alias netstat='ss'                               # Afficher les ports d'écoute (netstat n'existe plus)
alias md5='md5sum <<<'                           # Facilite l'utilisation de la commande md5
alias pubip='curl -s -4 ipecho.net/plain ; echo' # Pour obtenir l'adresse IP publique du serveur
alias df='df -h -x tmpfs -x devtmpfs -x overlay' # Commande df en filtrant les montages inutiles
alias halt='$sudo halt -p'                       # Arrête le système et le serveur
alias reboot='$sudo reboot'                      # Commande reboot avec sudo

# ssh
alias genkey='ssh-keygen -t ed25519 -a 100'
alias genkeyrsa='ssh-keygen -t rsa -b 4096 -a 100'
alias copykey='ssh-copy-id'

##################################################################
## Applications

# apt : gestionnaire de paquets
if [[ -f /usr/bin/apt ]]; then
alias apt='$sudo apt'
alias upgrade='$sudo apt update && $sudo apt full-upgrade && $sudo apt -y autoremove'
fi

# colordiff : diff avec couleur
if [[ -f /usr/bin/colordiff ]]; then
alias diff='colordiff'
fi

# duf : affiche les files systems
if [[ -f /usr/bin/duf ]]; then
alias df='duf -hide special'
fi

# fd : find amélioré
if [[ -f /usr/bin/fdfind ]]; then
alias fd='fdfind'
fi

# fzf : recherche avancée
if [[ -f /usr/bin/fzf ]]; then
source /usr/share/doc/fzf/examples/key-bindings.bash
fi

# htop : plus convivial que top
if [[ -f /usr/bin/htop ]]; then
alias top='htop'
fi

# ncdu : équivalent à TreeSize
if [[ -f /usr/bin/ncdu ]]; then
alias ncdu='ncdu --color dark'
fi

# podman : remplaçant de docker
if [[ -f /usr/bin/podman ]]; then
alias podman='$sudo podman'
alias docker='$sudo podman'
if [[ -f /usr/local/bin/lazydocker ]]; then
alias lzd='$sudo lazydocker'
fi
fi

# rg : plus performant que grep
if [[ -f /usr/bin/rg ]]; then
alias rg='rg -i'
fi

# tmux : émulateur de terminal
if [[ -f /usr/bin/tmux ]]; then
alias tmux='tmux attach || tmux new'
fi

# ufw : ajoute sudo
if [[ -f /usr/sbin/ufw ]]; then
alias ufw='$sudo ufw'
alias ufws='$sudo ufw status numbered'
fi

# vim : Vi amélioré
if [[ -f ~/.local/nvim/bin/nvim ]]; then
alias vi='nvim -nO'
elif [[ -f /usr/bin/vim ]]; then
alias vi='vim -nO'
fi

# zoxide : cd amélioré
if [[ -f /usr/bin/zoxide ]]; then
eval "$(zoxide init bash)"
alias cd='z'
fi

##################################################################
## Fonctions

# cpsave : copie un fichier ou un dossier avec .old
cpsave() { cp -Rp $1 "$(echo $1 | cut -d '/' -f 1)".old; }

# jsed : commande sed plus conviviale
jsed() { sed -i "s|$1|$2|g" $3; }

# newuser : créé un compte de service
newuser() {
$sudo adduser --no-create-home -q --disabled-password --comment "" $1
echo "Utilisateur $1 créé. ID : $(id -u $1)"
}

# tarc : créer une archive pour chaque fichier / dossier spécifié
tarc() { for file in $*; do tar czvf "$(echo $file | cut -d '/' -f 1)".tar.gz $file; done; }

# tarx : décompresse une archive spécifiée
tarx() { for file in $*; do tar xzvf $file; done; }

# zip : commande zip plus conviviale
zip() { /usr/bin/zip -r "$(echo "$1" | cut -d '/' -f 1)".zip $*; }

##################################################################
## Scripts

# Transforme en alias les scripts
scripts=/home/$(id -un 1000)/scripts
if [[ -d $scripts ]]; then
for i in $(ls $scripts); do
if [[ -f $scripts/$i/$i.sh ]]; then
alias $i=''$scripts'/'$i'/'$i'.sh'
fi
done
fi
```

Les aliases de base :

| Commande | Description |
| -------- | ------- |
| l        | Liste les fichiers et les répertoires |
| la       | Même chose que l, dont les cachés |
| lr       | Liste les fichiers et les répertoires en récursif |
| lra      | Même choseque lr, dont les cachés |
| lrt      | Liste les fichiers et les répertoires dans l'ordre chronologique |
| lrta     | Même chose que lrt, dont les cachés |
| grep     | Ajoute la gestion de la couleur à grep |
| zgrep    | Même chose pour zgrep (grep dans les fichiers compressés) |
| psp      | Suivi d'une chaîne, permet de rechercher rapidement un process |
| iostat   | Commande iostat, mais plus lisible |
| ifconfig | Utilise le programme ip (ifconfig n'existe plus sous Debian) |
| ss       | Remplaçant de netstat, mais épuré |
| ssp      | Suivi d'une chaîne, permet de rechercher rapidement un port d'écoute |
| netstat  | Utilise le programme ss (netstat n'existe plus sous Debian) |
| md5      | Suivi d'une chaîne, pour connaître rapidement un md5 |
| pubip    | Affiche rapidement l'IP publique de la machine |
| df       | Commande df, mais sans les volumes temporaires |
| halt     | Permet l'arrêt de la machine et non seulement le système |
| reboot   | Ajoute sudo devant la commande reboot |
| genkey   | Génère une clé au format ed25519 (plus sécurisé que rsa) |
| genkeyrsa| Génère une clé au format rsa en 4096 bits |
| copykey  | Parce que je me rappelle jamais de la commande ssh-copy-id |

Les aliases actifs uniquement dans le cas où les applications sont installées :

| Commande  | Description |
| --------- | -------- |
| apt       | Ajoute sudo et la commande `upgrade` |
| diff      | Remplace la commande par colordiff, pour une meilleure lisibilité |
| df        | Remplace la commande par duf, bien plus agréable visuellement |
| fd        | Outil équivalent à find mais bien plus simple à utiliser |
| fzf       | Outil de recherche avancé |
| top       | Remplace la commande top par htop |
| ncdu      | L'équivalent de l'outil Treesize sous Windows |
| podman    | Ajoute sudo devant, pour gagner du temps |
| docker    | Ajoute sudo devant, pour gagner du temps |
| lzd       | Lance l'outil lazydocker (console d'administration pour Docker) |
| rg        | Un grep récursif, bien plus lisible que le grep de base |
| tmux      | Transforme la commande de base pour s'assurer de ne pas en lancer plusieurs |
| ufw       | Un Firewall facile à utiliser, ajoute sudo devant |
| ufws      | Affiche le status de ufw, avec les règles numérotées |
| vi        | Adapte vi selon votre choix d'éditeur (Vim, NeoVim) |
| cd        | Utilise zoxide, un cd avancé |

Et enfin, les fonctions :

| Commande | Description |
| -------- | ------- |
| cpsave   | Créer une copie en .old d'un fichier ou d'un dossier spécifié |
| jsed     | Facilite l'utilisation de sed pour remplacer du texte |
| tarc     | Créer un tar.gz d'un ou plusieurs fichiers ou dossiers passés en paramètre |
| tarx     | Pour extraire un ou plusieurs tar.gz passés en paramètre |
| zip      | Facilite l'utilisation de la commande zip (zip \<fichier>) |

## Petit bonus : les aliases de scripts

Si vous avez quelques scripts, et que vous voulez y accéder depuis n'importe où facilement, vous pouvez ajouter ceci à la fin de votre fichier `.bash_aliases` :

```bash
## Scripts
scripts=/chemin/vers/vos/scripts
if [ -d $scripts ] ; then
for i in $(ls $scripts) ; do
if [ -f $scripts/$i/$i.sh ] ; then
alias $i=''$scripts'/'$i'/'$i'.sh'
fi
done
fi
```

Via ce petit bloc, un alias sera automatiquement créé pour chaque script qu'il trouvera dans un sous dossier qui porte le même nom. Par exemple, si un script nommé `test.sh` se trouve dans `/chemin/vers/vos/scripts/test`, un alias test sera créé.
Comme d'habitude, en cas de questions, n’hésitez pas :wink:
