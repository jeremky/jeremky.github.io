---
title: "Mise à jour de ma configuration Vi"
slug: mise-a-jour-de-ma-config-vi
date: 2024-09-18T16:33:53+02:00
useRelativeCover: true
cover: cover.webp
tags:
  - linux
categories:
  - Tutos
toc: false
draft: false
---

Petit article pour vous partager les changements sur ma configuration de [Vim](https://www.vim.org/). Pour rappel, un article avait été rédigé sur comment utiliser et configurer Vim. L'article est [disponible ici](/posts/vi-na-pas-dit-son-dernier-mot).

Ce qui va suivre peut très bien être implémenté via des modules Vim. Mais ce n'est pas l'objectif ici, qui est d'utiliser les possibilités de base de Vim afin d'avoir une configuration la plus portable possible via un seul fichier.

## Ajout d'un explorateur de fichier

A l'ouverture d'un fichier, nous avons désormais sur notre gauche un explorateur de fichiers, se plaçant dans le répertoire courant :

{{< image src="screen.webp" style="border-radius: 8px;" >}}

Pour se rendre au panneau de gauche, vous pouvez utiliser le raccourci `Ctrl + w w`. Sélectionner un fichier en validant avec `Entrée` l'ouvrira automatiquement dans le panneau de droite.

Pour que cela soit possible, voici les éléments qui ont été ajoutés dans le fichier `vimrc` :

```vim
"" Explorateur de fichiers
let g:netrw_liststyle = 3       " Active le mode Treeview
let g:netrw_sizestyle = "H"     " Active le mode human-readable
let g:netrw_banner = 0          " Désactive la bannière
let g:netrw_browse_split = 4    " Ouvre le fichier choisi dans un panel
let g:netrw_altv = 1            " Ouvre en mode vertical
let g:netrw_winsize = 15        " Définit la taille de l'explorateur

"" Ouvre automatiquement l'explorateur
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
  autocmd VimEnter * wincmd w
augroup END

"" Ferme automatiquement l'explorateur
aug netrw_close
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw"|q|endif
aug END
```

> L'ouverture automatique de l'explorateur de fichiers a finalement été désactivé par dans le fichier de configuration. A la place, il vous suffit d'appuyer sur `F1` lorsque vous en avez besoin.

## Gestion de la souris

Il est possible d'utiliser la souris pour passer de l'explorateur au fichier ouvert. Pour cela, ma configuration permet d'activer la souris via la touche `F6`. Vous pourrez alors naviguer dans un fichier directement en utilisant la roulette, et cliquer là où vous désirez placer notre curseur. Cela fonctionne également pour se rendre dans l'explorateur de fichiers.

Attention cependant : lorsque vous sélectionnez du texte, l'éditeur passe maintenant en mode "insertion (visuel)" automatiquement. A noter que pour copier du texte sélectionné, il faut faire `y` pour copier, et `d` pour couper. Enfin, `p` pour coller. Il faut savoir également que coller du texte externe à Vi nécessite d'avoir un terminal compatible avec le raccourci `Ctrl+v`, le clique droit n'étant plus possible.
