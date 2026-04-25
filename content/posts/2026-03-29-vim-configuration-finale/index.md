---
title: "Vim : configuration finale"
slug: vim-configuration-finale
date: 2026-03-29T15:47:11+01:00
useRelativeCover: true
cover: cover.webp
tags:
  - linux
categories:
  - Tutos
toc: true
draft: false
---

Plusieurs articles ont été rédigés sur ce site pour présenter Vi et ses dérivés. J'avais pris le temps de présenter [son fonctionnement](/posts/vi-na-pas-dit-son-dernier-mot/), son fork [Neovim](/posts/neovim-un-fork-de-vim-moderne/), ainsi que [différentes configurations](/posts/vim-neovim-choisissez-votre-configuration/) avec une multitude de plugins selon vos usages.

Finalement, avec le recul, malgré son efficacité qui est indéniable, j'ai fini par revenir en arrière sur l'utilisation de cet éditeur.

## Pourquoi ?

Vi, étant un éditeur à utiliser en terminal, c'est surtout lors de connexions à des serveurs que son usage est le plus pertinent. Et même s'il est disponible localement sur macOS ou sur les distributions Linux, il souffre d'une comparaison avec les éditeurs "modernes".

Du coup... Neovim se trouve dans une situation un peu "bâtarde" pour mon usage. Il n'en fait pas assez de base, et devient un enfer à configurer avec tous les plugins à gérer manuellement (Même si [LazyVim](https://www.lazyvim.org/) est sensé faciliter les choses).

Vim, étant installé par défaut sur la majorité des distributions, j'ai préféré revenir sur une configuration simplifiée, avec un nombre raisonnable de plugins, afin de privilégier la performance, notamment sur Raspberry Pi.

Restait à trouver des solutions desktop.

## La suite ?

Pour mes besoins d'édition de code ou de ce site, j'ai donc exploré d'autres alternatives.

Nous avons tout d'abord [Visual Studio Code](https://code.visualstudio.com/), que je n'ai pas à présenter, et son alternative Open Source, [VSCodium](https://vscodium.com/). VS Code dispose d'une myriade de plugins, dont l'excellent [Front Matter](https://frontmatter.codes/), que j'utilise actuellement pour la rédaction de ce site.

Et plus récemment, j'ai découvert l'IDE [Zed](https://zed.dev/), un éditeur créé par les anciens de Atom, qui est pensé pour être particulièrement performant, de par son langage récent (Rust) et son fonctionnement par extension. Il dispose également d'une intégration des agents IA pour le prompt et la complétion de code. Et, cerise sur le gâteau, il possède un mode Vim... Le meilleur des 2 mondes :smile:

## Fichier .vimrc

Je vous mets donc à disposition ma configuration actuelle, qui, je pense, n'évoluera plus. Ce fichier est à créer sous `~/.vimrc`, ou `~/.vim/vimrc`.

> Avant de lancer Vim une fois le fichier créé, assurez-vous que git et curl sont installés. Il sont nécessaires pour le téléchargement de [vim-plug](https://github.com/junegunn/vim-plug) et des plugins

```vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration de vim

" Paramétrage de base
set nocompatible                " Désactive la compatibilité Vi
set hlsearch                    " Affiche en surbrillance les recherches
set background=dark             " Optimise l'affiche pour un terminal sombre
set smartindent                 " Indentation intelligente
set smarttab                    " Gestion des espaces en début de ligne
set autoindent                  " Conserve l'indentation sur une nouvelle ligne
set ruler                       " Affiche la position du curseur
set tabstop=2                   " La largeur d'une tabulation est définie sur 2
set shiftwidth=2                " Les retraits auront une largeur de 2
set softtabstop=2               " Nombre de colonnes pour une tabulation
set expandtab                   " Remplace les tab par des espaces
set linebreak                   " Revient à la ligne sans couper les mots
set showcmd                     " Afficher la commande dans la ligne d'état
set showmatch                   " Afficher les parenthèses correspondantes
set ignorecase                  " Ignorer la casse
set smartcase                   " Faire un appariement intelligent
set incsearch                   " Recherche incrémentielle
set hidden                      " Cacher les tampons lorsqu'ils sont abandonnés
set mouse=                      " Désactive la souris par défaut
set nobackup                    " Désactive les sauvegardes automatiques

" Permet l'indentation automatique : gg=G
filetype plugin indent on

" Definition des caractères invisibles
let &listchars = "eol:$,space:\u00B7"

" Changement automatique du curseur en fonction du mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Mémoriser la dernière position du curseur
autocmd BufReadPost * if (line("'\"") > 1) && (line("'\"") <= line("$")) | silent exe "silent! normal g'\"zO" | endif

" Désactivation des # au retour chariot
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fonctions

function! ModeIDE()
  if get(g:, 'modeIDE_enabled', 0)
    let g:modeIDE_enabled = 0
    for w in range(1, winnr('$'))
      execute w . 'wincmd w'
      set nonumber mouse=
    endfor
    echo "Mode IDE désactivé"
  else
    let g:modeIDE_enabled = 1
    for w in range(1, winnr('$'))
      execute w . 'wincmd w'
      set number mouse=a
    endfor
    echo "Mode IDE activé"
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapping

" Mode IDE
nnoremap <F2> <Cmd>call ModeIDE()<CR>

" Affichage des caractères invisibles
nnoremap <F3> <Cmd>set list!<CR>

" Commentaire
nnoremap <F4> <Plug>CommentaryLine
xnoremap <F4> <Plug>Commentary

" Indentation automatique
nnoremap <F5> gg=G<CR>

" Ménage des plugins
nnoremap <F7> <Cmd>PlugClean<CR>

" MAJ des plugins
nnoremap <F8> <Cmd>PlugUpdate<CR>

" Changement de document
nnoremap <S-TAB> <C-W>w

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Installation des Plugins

" Téléchargement de vim-plug si introuvable
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ <https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim>
endif

" Lance automatiquement PlugInstall
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \| PlugInstall --sync | source $MYVIMRC
      \| endif

" Liste des plugins
call plug#begin()

" Interface
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'itchyny/lightline.vim'

" Edition
Plug 'tpope/vim-commentary'
Plug 'vim-scripts/VimCompletesMe'

" Code
Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration des Plugins

if isdirectory(expand("~/.vim/plugged"))

  " Catppuccin
  colorscheme catppuccin_mocha
  set cursorline
  set termguicolors

  " LightLine
  let g:lightline = {'colorscheme': 'catppuccin_mocha'}
  let g:lightline.separator = { 'left': '', 'right': '' }
  set laststatus=2
  set noshowmode

  " AutoPairs
  let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'"}

endif
```

Par rapport aux versions précédentes, voici les changements :

- Utilisation du thème Catppuccin Mocha
- Configuration de la barre Lightline assortie
- Le plugin vim-commentary pour commenter/décommenter rapidement
- Le plugin auto-pairs pour fermer automatiquement certains brackets
- Et vim-polyglot, qui permet un meilleur affichage du code

Je vous laisse regarder la partie Mapping pour voir quelles touches ont été attribuées.

## Conclusion

Finalement, vouloir un outil pour tout faire n'est pas forcément une bonne solution. Diviser les applications selon les usages permet d'améliorer sa productivité. Un Vim, simple, efficace, pour des modifications rapides, via ssh, et un IDE, comme VS Code ou Zed pour de l'édition plus poussée avec des fonctionnalités pré-installées.
