---
title: "Personnalisation du prompt Linux"
slug: personnalisation-du-prompt-linux
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

Là encore, le plus simple, c'est que je vous partage le fichier que j'utilise.
Il est utilisable aussi bien pour votre user que pour root. Attention dans ce cas, le fichier ne se charge pas par défaut. Il faut ajouter dans le fichier `.bashrc` de root les lignes suivantes :

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

Vous pouvez le récupérer directement sur github en suivant [ce lien](https://github.com/jeremky/envbackup/blob/main/dotfiles/debian/.bash_aliases).

Le contenu du fichier :

```bash
###############################################################
## Bash

# Affichage
if [[ $USER = root ]]; then
  PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
  PS1='\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
fi

# Variables
export LANG=fr_FR.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG
export EDITOR=vim
export VISUAL=$EDITOR
export HISTTIMEFORMAT="%F %T "
export TMOUT=1800

# Tweaks divers
if [[ $- == *i* ]]; then
  bind 'set colored-stats on'              # Affiche les couleurs lors de la complétion
  bind 'set completion-ignore-case on'     # Ignorer la casse lors de la complétion
  bind 'set show-all-if-unmodified on'     # Affiche les correspondances possibles immédiatement
fi

###############################################################
## Commandes

# Prompt
alias ls='ls --color=auto'                         # Ajoute la couleur
alias l='ls -lh'                                   # Liste détaillée
alias la='ls -lhA'                                 # Liste avec les fichiers cachés
alias lr='ls -lLhR'                                # Liste en récursif
alias lra='ls -lhRA'                               # Liste en récursif avec les fichiers cachés
alias lrt='ls -lLhrt'                              # Liste par date
alias lrta='ls -lLhrtA'                            # Liste par date avec les fichiers cachés
alias dus='du -sh * | sort -hr'                    # Tri de fichiers et dossiers par taille
alias grep='grep -i --color=auto'                  # Grep sans la sensibilité à la casse
alias zgrep='zgrep -i --color=auto'                # Grep dans les fichiers compressés
alias psp='ps -eaf | grep -v grep | grep'          # Chercher un process (psp <nom process>)
alias iostat='iostat -m --human'                   # Commande iostat lisible
alias ifconfig='ip -br -c addr | grep -v lo'       # Afficher les adresses IP (ifconfig n'existe plus)
alias ss='ss -tunlH'                               # Afficher les ports d'écoute
alias ssp='ss | grep'                              # Chercher un port (ssp <port>)
alias md5='md5sum <<<'                             # Facilite l'utilisation de la commande md5
alias pubip='curl -s -4 ipecho.net/plain ; echo'   # Pour obtenir l'adresse IP publique du serveur
alias df='df -h -x tmpfs -x devtmpfs -x overlay'   # Commande df en filtrant les montages inutiles
alias halt='sudo halt -p'                          # Arrête le système et le serveur
alias reboot='sudo reboot'                         # Commande reboot avec sudo

# sudo : utiliser la commande root pour...passer root :)
[[ $USER != root ]] && alias root='sudo -s'

# ssh
alias genkey='ssh-keygen -t ed25519 -a 100'        # Générer une clé ed25519
alias genkeyrsa='ssh-keygen -t rsa -b 4096 -a 100' # Générer une clé RSA
alias copykey='ssh-copy-id'                        # Copier la clé ssh vers un serveur

###############################################################
## Applications facultatives

# apt : gestionnaire de paquets debian
if [[ -f /usr/bin/apt ]]; then
  alias apt='sudo apt'
  alias upgrade='sudo apt update && sudo apt full-upgrade && sudo apt -y autoremove'
fi

# colordiff : diff avec couleur
[[ -f /usr/bin/colordiff ]] && alias diff='colordiff'

# duf : df amélioré
[[ -f /usr/bin/duf ]] && alias df='duf -hide special'

# fd : find amélioré
[[ -f /usr/bin/fdfind ]] && alias fd='fdfind -HI'

# fzf : recherche avancée
if [[ -f /usr/bin/fzf ]]; then
  eval "$(fzf --bash)"
  export FZF_DEFAULT_OPTS="--color=bw"
fi

# htop : plus convivial que top
[[ -f /usr/bin/htop ]] && alias top='htop'

# ncdu : équivalent à TreeSize
[[ -f /usr/bin/ncdu ]] && alias ncdu='ncdu --color dark'

# rg : plus performant que grep
[[ -f /usr/bin/rg ]] && alias rg='rg -i --no-ignore'

# tty-clock : horloge en cli
[[ -f /usr/bin/tty-clock ]] && alias clock='tty-clock -c -f %d/%m/%Y'

# ufw : firewall simplifié
if [[ -f /usr/sbin/ufw ]]; then
  alias ufw='sudo ufw'
  alias ufws='sudo ufw status numbered'
fi

# vim : vi amélioré
[[ -f /usr/bin/vim ]] && alias vi='vim -nO'

# zoxide : cd amélioré (utiliser la commande z)
[[ -f /usr/bin/zoxide ]] && eval "$(zoxide init bash)"

###############################################################
## Fonctions

# cleanlog : ménage des logs de systemd
cleanlog() { [[ -n "$1" ]] && sudo journalctl --vacuum-time=${1}d ;}

# cpsave : copie un fichier ou un dossier avec .old
cpsave() { cp -Rp "$1" "${1%/}.$(date +%Y%m%d).old" ;}

# gencert : générer un certificat avec certbot
gencert () { sudo certbot certonly --standalone -d "$1" ;}

# newuser : créé un compte de service
newuser() {
  sudo adduser --no-create-home -q --disabled-password --comment "" $1
  echo "Utilisateur $1 créé. ID : $(id -u $1)"
}

# tarc : créer une archive pour chaque fichier / dossier spécifié
tarc() { for file in "$@"; do tar czvf "${file%/}.tar.gz" -- "$file"; done ;}

# tarx : décompresse une archive spécifiée
tarx() { for file in "$@"; do tar xzvf -- "$file"; done ;}

# testdisk
testdisk() { dd if=/dev/zero of=testfile bs=64M count=16 oflag=direct status=progress ; rm testfile ;}

# zip : commande zip plus conviviale
zip() { for file in "$@"; do /usr/bin/zip -r "${file%/}.zip" "$file" ; done ;}
```

Les aliases de base :

| Commande  | Description |
| --------- | --------- |
| l         | Liste les fichiers et les répertoires |
| la        | Même chose que l, dont les cachés |
| lr        | Liste les fichiers et les répertoires en récursif |
| lra       | Même choseque lr, dont les cachés |
| lrt       | Liste les fichiers et les répertoires dans l'ordre chronologique |
| lrta      | Même chose que lrt, dont les cachés |
| grep      | Ajoute la gestion de la couleur à grep |
| zgrep     | Même chose pour zgrep (grep dans les fichiers compressés) |
| psp       | Suivi d'une chaîne, permet de rechercher rapidement un process |
| iostat    | Commande iostat, mais plus lisible |
| ifconfig  | Utilise le programme ip (ifconfig n'existe plus sous Debian) |
| ss        | Remplaçant de netstat, mais épuré |
| ssp       | Suivi d'une chaîne, permet de rechercher rapidement un port d'écoute |
| netstat   | Utilise le programme ss (netstat n'existe plus sous Debian) |
| md5       | Suivi d'une chaîne, pour connaître rapidement un md5 |
| pubip     | Affiche rapidement l'IP publique de la machine |
| df        | Commande df, mais sans les volumes temporaires |
| halt      | Permet l'arrêt de la machine et non seulement le système |
| reboot    | Ajoute sudo devant la commande reboot |
| genkey    | Génère une clé au format ed25519 (plus sécurisé que rsa) |
| genkeyrsa | Génère une clé au format rsa en 4096 bits |
| copykey   | Parce que je me rappelle jamais de la commande ssh-copy-id |

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
| rg        | Un grep récursif, bien plus lisible que le grep de base |
| clock     | Lance tty-clock, un petit outil pour afficher l'heure |
| ufw       | Un Firewall facile à utiliser, ajoute sudo devant |
| ufws      | Affiche le status de ufw, avec les règles numérotées |
| vi        | Adapte vi selon votre choix d'éditeur (Vim, Neovim) |
| cd        | Utilise zoxide, un cd avancé |

Et enfin, les fonctions :

| Commande | Description |
| -------- | ------- |
| cleanlog | Supprimer les logs systemd en spécifiant le nombre de jours |
| cpsave   | Créer une copie en date.old d'un fichier ou d'un dossier spécifié |
| gencert  | Générer un certificat en précisant le nom de domaine en paramètre |
| newuser  | Créer un compte de service (pas de home ni de mot de passe) |
| tarc     | Créer un tar.gz d'un ou plusieurs fichiers ou dossiers passés en paramètre |
| tarx     | Pour extraire un ou plusieurs tar.gz passés en paramètre |
| testdisk | Tester la vitesse du disque courant en créant un fichier |
| zip      | Facilite l'utilisation de la commande zip (zip \<fichier>) |

## Petit bonus : les aliases de scripts

Si vous avez quelques scripts, et que vous voulez y accéder depuis n'importe où facilement, vous pouvez ajouter ceci à la fin de votre fichier `.bash_aliases` :

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

Via ce petit bloc, un alias sera automatiquement créé pour chaque script qu'il trouvera dans un sous dossier qui porte le même nom. Par exemple, si un script nommé `test.sh` se trouve dans `/chemin/vers/vos/scripts/test`, un alias test sera créé. Comme d'habitude, en cas de questions, n’hésitez pas :wink:
