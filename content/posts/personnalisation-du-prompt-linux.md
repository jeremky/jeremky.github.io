---
title: "Personnalisation du prompt Linux"
date: 2024-05-02T17:13:12Z
cover: "/img/posts/personnalisation-du-prompt-linux/cover.webp"
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

Vous pouvez le récupérer directement sur github en suivant [ce lien](https://github.com/jeremky/envbackup.sh/blob/main/dotfiles/.bash_aliases).

Le contenu du fichier :

```bash
###### Aliases ######

## Variables
export LANG=fr_FR.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG
export EDITOR=vi
export VISUAL=$EDITOR

## Tweaks
bind 'set completion-ignore-case on'

## Sudo
if [ -f /usr/bin/sudo ] && [ "$USER" != "root" ] ; then
    alias su='sudo -s'
    sudo=sudo
else
    alias su='su -'
fi

## Aliases
alias l='ls -lh'
alias la='ls -lhA'
alias lr='ls -lLhR'
alias lra='ls -lRha'
alias lrt='ls -lLhrt'
alias lart='ls -lLhArt'
alias grep='grep -i --color=auto'
alias zgrep='zgrep -i --color=auto'
alias vi='vi -nO'
alias view='vi -nRO'
alias df='df -h -x overlay -x tmpfs -x devtmpfs'
alias psp='ps -eaf | grep -v grep | grep'
alias iostat='iostat -m --human'
alias ifconfig='ip -br -c addr | grep -v lo'
alias netstat='ss -lpn'
alias ss='ss -tunlH'
alias ssp='ss -tunl | grep'
alias md5='md5sum <<<'
alias pubip='curl -s -4 ipecho.net/plain ; echo'
alias upgrade='$sudo apt update && $sudo apt full-upgrade && $sudo apt -y autoremove'
alias wget='wget --no-check-certificate'
alias newuser='$sudo adduser --no-create-home -q --disabled-password --gecos ""'
alias halt='$sudo halt -p'

## Ssh
alias genkey='ssh-keygen -t ed25519 -a 100'
alias genkeyrsa='ssh-keygen -t rsa -b 4096 -a 100'
alias copykey='ssh-copy-id'

## Top
if [ -f /usr/bin/htop ] ; then
    alias top='htop'
fi

## Ncdu
if [ -f /usr/bin/ncdu ] ; then
    alias ncdu='ncdu --color dark'
fi

## Ufw
if [ -f /usr/sbin/ufw ] ; then
    alias ufw='$sudo ufw'
    alias ufws='$sudo ufw status numbered'
fi

## Diff
if [ -f /usr/bin/colordiff ] ; then
    alias diff='colordiff'
fi

## Df
if [ -f /usr/bin/duf ] ; then
    alias df='duf --hide special'
fi

## Ripgrep
if [ -f /usr/bin/rg ] ; then
    alias rg='rg -i'
fi

## Docker
if [ -f /usr/bin/docker ] ; then
    alias docker='$sudo docker'
fi

## Lazydocker
if [ -f /usr/bin/lazydocker ] ; then
    alias lzd='$sudo lazydocker'
fi

## Fonctions
cpsave() { cp -Rp $1 "$(echo $1 | cut -d '/' -f 1)".old ;}
zip() { /usr/bin/zip -r "$(echo $1 | cut -d '/' -f 1 | cut -d '.' -f 1)".zip "$*" ;}

tarc() { for file in $* ; do tar czvf "$(echo $file | cut -d '/' -f 1)".tar.gz $file ; done ;}
tarx() { for file in $* ; do tar xzvf $file ; done ;}

gpgc() { gpg -c "$1" ;}
gpgd() { for file in $* ; do gpg -o "$(basename "$file" .gpg)" -d "$file" ; done ;}

gencert() { read -p "Adresse mail : " mail ; $sudo certbot certonly --standalone --preferred-challenges http --email $mail -d $1 ;}
rencert() { $sudo certbot -q renew ;}
```

Les aliases de base :

| Commande | Description |
| -------- | ------- |
| l        | Liste les fichiers et les répertoires |
| la       | Même chose que l, dont les cachés |
| lr       | Liste les fichiers et les répertoires en récursif |
| lra      | Même choseque lr, dont les cachés |
| lrt      | Liste les fichiers et les répertoires dans l'ordre chronologique |
| lart     | Même chose que lrt, dont les cachés |
| grep     | Ajoute la gestion de la couleur à grep |
| zgrep    | Même chose pour zgrep (grep dans les fichiers compressés) |
| vi       | Permet d'ouvrir plusieurs fichiers simulatanément |
| view     | Même chose pour view |
| df       | Commande df, mais sans les volumes temporaires |
| psp      | Suivi d'une chaîne, permet de rechercher rapidement un process |
| iostat   | Commande iostat, mais plus lisible |
| ifconfig  | Utilise le programme ip (ifconfig n'existe plus sous Debian) |
| netstat  | Utilise le programme ss (netstat n'existe plus sous Debian) |
| ss       | Remplaçant de netstat, mais épuré |
| ssp      | Suivi d'une chaîne, permet de rechercher rapidement un port d'écoute |
| md5      | Suivi d'une chaîne, pour connaître rapidement un md5 |
| pubip    | Affiche rapidement l'IP publique de la machine |
| upgrade  | Lance les opérations d'upgrade OS en une seule commande |
| wget     | Modifie wget pour autoriser les url https sans certificat valide |
| newuser  | Créer un compte de service (pas de $HOME ni de mot de passe) |
| halt     | Permet l'arrêt de la machine et non seulement le système |
| genkey   | Génère une clé au format ed25519 (plus sécurisé que rsa) |
| genkeyrsa| Génère une clé au format rsa en 4096 bits |
| copykey  | Parce que je me rappelle jamais de la commande ssh-copy-id |

Les aliases actifs uniquement dans le cas où les applications sont installées :

| Commande | Description |
| -------- | ------- |
| top      | Remplace la commande top par htop |
| ncdu     | L'équivalent de l'outil Treesize sous Windows |
| ufw      | Un Firewall facile à utiliser, ajoute sudo devant |
| ufws     | Affiche le status de ufw, avec les règles numérotées |
| diff     | Remplace la commande par colordiff, pour une meilleure lisibilité |
| df       | Remplace la commande par duf, bien plus agréable visuellement |
| rg       | Un grep récursif, bien plus lisible que le grep de base |
| docker   | Ajoute sudo devant, pour gagner du temps |
| lzd      | Lance l'outil lazydocker (console d'administration pour Docker) |

Et enfin, les fonctions :

| Commande | Description |
| -------- | ------- |
| cpsave   | Créer une copie en .old d'un fichier ou d'un dossier spécifié |
| zip      | Facilite l'utilisation de la commande zip (zip \<fichier>) |
| tarc     | Créer un tar.gz d'un ou plusieurs fichiers ou dossiers passés en paramètre |
| tarx     | Pour extraire un ou plusieurs tar.gz passés en paramètre |
| gpgc     | Chiffre un fichier en .pgp avec protection par mot de passe |
| gpgd     | Déchiffre un ou plusieurs fichiers pgp protégés par mot de passe |
| gencert  | Permet de créer un certificat. Une adresse mail sera demandée |
| rencert  | Pour renouveler les certificats créés via gencert |

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
