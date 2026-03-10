---
title: "Personnalisation du prompt MacOS"
slug: personnalisation-du-prompt-macos
date: 2026-03-09T17:13:12Z
useRelativeCover: true
cover: cover.webp
tags:
  - macos
categories:
  - Tutos
toc: true
draft: true
---

J'avais écrit [un article]() afin de personnaliser votre prompt Linux fonctionnant avec bash. Cette fois-ci, nous allons nous attaquer à MacOS, qui fonctionne avec Zsh.

## Explication

Au démarrage d'une session shell, différents fichiers se chargent automatiquement. Cela permet de charger les configurations nécessaires au fonctionnement du prompt, comme son apparence, les variables d'environnement...

Dans le home directory, se trouvent des fichiers cachés contenant ces informations :

- le fichier `.profile`, pour déterminer l'emplacement des binaires/commandes que l'on utilise, et le shell qui est utilisé (dans notre cas, zsh)
- le fichier `.zshrc`, pour configurer zsh (l'apparence du prompt, la longueur de l'historique des commandes, le chargement des complétions de commandes...)

## Fichier .zsh_aliases

Afin de garder une cohérence avec le système Linux, nous allons créer un fichier `.zsh_aliases`. Ce fichier contiendra nos personnalisations, notamment les aliases, qui permettent de se créer des "raccourcis" de commande, ou des fonctions. Le fichier est lu comme un script, il est donc possible d'y placer des conditions, ou des boucles.

Le fichier `.zshrc` fourni par défaut par MacOS ne contient pas de bloc pour charger le fichier d'alias. Il faut donc y ajouter les lignes suivantes :

```zsh
# Alias definitions.
if [[ -f ~/.zsh_aliases ]]; then
. ~/.zsh_aliases
fi
```

Mon fichier `.zsh_aliases` se divise en plusieurs parties :

- La définition de certaines variables d'environnement (langue, éditeur par défaut)
- Un paramètre pour ignorer la casse lors de la saisie (remplace automatiquement les caractères concernés lors d'une tabulation)
- La liste des aliases de base que j'utilise
- Des aliases supplémentaires pour des applications spécifiques, chargés uniquement si les applications sont installées
- Quelques fonctions, dans le cas où un simple alias est trop limitant

Le contenu du fichier :

```zsh
##################################################################
## Zsh

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
| vi        | Adapte vi selon votre choix d'éditeur (Vim, Neovim) |
| cd        | Utilise zoxide, un cd avancé |

Et enfin, les fonctions :

| Commande | Description |
| -------- | ------- |
| cpsave   | Créer une copie en date.old d'un fichier ou d'un dossier spécifié |
| tarc     | Créer un tar.gz d'un ou plusieurs fichiers ou dossiers passés en paramètre |
| tarx     | Pour extraire un ou plusieurs tar.gz passés en paramètre |
| zip      | Facilite l'utilisation de la commande zip (zip \<fichier>) |

## Petit bonus : les aliases de scripts

Si vous avez quelques scripts, et que vous voulez y accéder depuis n'importe où facilement, vous pouvez ajouter ceci à la fin de votre fichier `.zsh_aliases` :

```zsh
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

Via ce petit bloc, un alias sera automatiquement créé pour chaque script qu'il trouvera dans un sous dossier qui porte le même nom. Par exemple, si un script nommé `test.sh` se trouve dans `/chemin/vers/vos/scripts/test`, un alias test sera créé. Comme d'habitude, en cas de questions, n’hésitez pas :wink:
