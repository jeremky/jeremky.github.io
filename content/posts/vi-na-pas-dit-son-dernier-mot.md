---
title: "Vi n'a pas dit son dernier mot"
date: 2024-05-01T17:12:08Z
cover: "/img/posts/vi-na-pas-dit-son-dernier-mot/cover.webp"
tags:
    - linux
categories:
    - Tutos
toc: true
draft: false
---

Aujourd'hui, je vous propose de parler de l'éditeur de fichiers vi. Parmi ceux qui le connaissent, il y a ceux qui l'adorent, et ceux qui en sont allergiques... Sûrement parce que sans un peu d'entraînement, c'est effectivement un enfer à utiliser. Mais une fois qu'on s'habitue aux commandes de base, et qu'on l'a suffisamment personnalisé, il devient un outil extrêmement productif ! :sunglasses:

## Installation de la version Improved

Selon les distributions, la version Improved n'est pas forcément installée. Sur une distribution basée sur Debian :

```sh
sudo apt install vim
```

Une fois Vim installé, la commande vi devient un alias qui pointe vers ce dernier.

## Les commandes de base

Voici un tableau contenant les commandes principales de Vi :

| Commande | Description |
| -------- | ------- |
| Esc | Quitter le mode édition et repasser en mode commande |
| i   | Entrer en mode insertion |
| a   | Entrer en mode insertion après le curseur |
| A   | Entrer en mode insertion à la fin de la ligne |
| D   | Effacer le reste de la ligne à partir du curseur |
| C   | Effacer le reste de la ligne et entrer en mode édition |
| cw  | Effacer le mot et entrer en mode édition |
| u   | Annuler la dernière action |
| :w  | Enregistrer le fichier |
| :wq | Enregistrer le fichier et quitter |
| :q! | Quitter sans enregistrer les modifications |
| dd  | Supprimer/couper la ligne courante |
| yy  | Copier la ligne courante |
| p   | Coller sous la ligne courante |
| P   | Coller avant la ligne courante |
| w   | Aller au mot suivant |
| b   | Aller au mot précédent |
| $   | Aller à la fin de la ligne |
| 0   | Aller au début de la ligne |
| gg  | Aller au début du fichier |
| G   | Aller à la fin du fichier |
| /   | Suivi d'une saisie d'une chaîne à rechercher |
| n   | Rechercher l’occurrence suivante |
| N   | Rechercher l’occurrence précédente |
| *   | Rechercher les occurrences d'une chaîne à la position du curseur. * pour suivant |

La liste est loin d'être exhaustive, mais vous avez déjà une bonne base pour éditer efficacement.

## La personnalisation

Vi est par défaut assez austère, mais il est possible de passer de cette interface :

{{< image src="/img/posts/vi-na-pas-dit-son-dernier-mot/vi_default.webp" style="border-radius: 8px;" >}}

A ceci :

{{< image src="/img/posts/vi-na-pas-dit-son-dernier-mot/vi_themed.webp" style="border-radius: 8px;" >}}

La personnalisation de Vi se fait dans un fichier que l'on nommera `vimrc` à placer ici : `/home/<user>/.vim/vimrc`). Il est possible d'indiquer des configurations propres à Vi, mais aussi de mapper des touches du clavier à certaines fonctions personnalisées. A noter aussi que Vi a son propre langage de scripting, afin par exemple de lui indiquer des conditions.

Le plus simple, c'est que vous récupériez mon fichier `vimrc`, disponible [ici](/files/vi-na-pas-dit-son-dernier-mot/vimrc). Il est suffisamment commenté pour comprendre chaque paramètre.

Pour le mapping des touches, voici ce qui est en place grâce à ce fichier :

- F2 : Permet de mettre en couleurs les mots mal orthographiés. La première fois, Vi vous proposera de télécharger les fichiers de langue nécessaires
- F3 : Affiche ou non les numéros de ligne
- F4 : Désactive / active la coloration syntaxique (pour ceux qui sont gênés par les couleurs)
- F5 : Permet d'effectuer une indentation automatique sur l'intégralité du fichier
- F6 : Active / désactive la gestion de la souris. Je ne l'active pas par défaut car la gestion du copier / coller est assez particulière
- F7 : Affiche les caractères de fin de ligne. Pratique si un espace invisible s'est glissé quelque part dans un script

## Le thème OneHalfDark

Vi possède une quantité dingue de thèmes différents. Personnellement, j'utilise le thème [OneHalfDark](https://github.com/sonph/onehalf) :

{{< image src="/img/posts/vi-na-pas-dit-son-dernier-mot/vi_perso.webp" style="border-radius: 8px;" >}}

Il est disponible sur la plupart des outils d'édition, et sur les terminaux les plus utilisés, dont l'excellent Windows Terminal de Microsoft.

Pour ajouter vos thèmes, il suffit de les déposer ici : `/home/votre_user/.vim/colors` (`mkdir -p $HOME/.vim/colors` si le dossier n'existe pas).

Ayant apporté quelques modifications dessus, je vous partage ma version modifiée directement [ici](/files/vi-na-pas-dit-son-dernier-mot/onehalfdark.vim).

Le fichier `vimrc` que j'ai mis à disposition plus haut chargera automatiquement ce thème si le fichier `onehalfdark.vim` est présent et que votre terminal est compatible.

## Conclusion

Toutes ces modifications ne sont qu'une porte d'entrée à tout ce qu'il est possible de personnaliser dans Vi. Pour ceux qui souhaiteraient aller encore plus loin, il existe tout un tas de plugins supplémentaires. Mais par expérience, je trouve que cela finit par l'alourdir par rapport à mes besoins.

Si vous avez des questions particulières, vous savez où me trouver :wink:
