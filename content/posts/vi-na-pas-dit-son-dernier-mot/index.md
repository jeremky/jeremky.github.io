---
title: "Vi n'a pas dit son dernier mot"
slug: vi-na-pas-dit-son-dernier-mot
date: 2024-05-01T17:12:08Z
useRelativeCover: true
cover: cover.webp
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

{{< image src="vi_default.webp" style="border-radius: 8px;" >}}

A ceci :

{{< image src="vi_themed.webp" style="border-radius: 8px;" >}}

La personnalisation de Vi se fait dans un fichier que l'on nommera `vimrc` à placer ici : `/home/<user>/.vim/vimrc`). Il est possible d'indiquer des configurations propres à Vi, mais aussi de mapper des touches du clavier à certaines fonctions personnalisées. A noter aussi que Vi a son propre langage de scripting, afin par exemple de lui indiquer des conditions.

Le plus simple, c'est que vous récupériez mon fichier `vimrc` :

{{< code language="vim" title="Fichier vimrc" id="1" expand="Afficher" collapse="Cacher" isCollapsed="true" >}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration de Vim

" Paramétrage de base
syntax on                       " Active la colorisation syntaxique
set hlsearch                    " Affiche en surbrillance les recherches
set background=dark             " Optimise l'affiche pour un terminal sombre
set laststatus=2                " Affiche en permanence la barre de statut
set smartindent                 " Indentation intelligente
set smarttab                    " Gestion des espaces en debut de ligne
set autoindent                  " Conserve l'indentation sur une nouvelle ligne
set ruler                       " Affiche la position du curseur
set tabstop=2                   " La largeur d'une tabulation est définie sur 2
set shiftwidth=2                " Les retraits auront une largeur de 2
set softtabstop=2               " Nombre de colonnes pour une tabulation
set expandtab                   " Remplace les tab par des espaces
set linebreak                   " Revient à la ligne sans couper les mots
set showcmd                     " Afficher la commande dans la ligne d’état
set showmatch                   " Afficher les parentheses correspondantes
set ignorecase                  " Ignorer la casse
set smartcase                   " Faire un appariement intelligent
set incsearch                   " Recherche incrémentielle
set hidden                      " Cacher les tampons lorsqu'ils sont abandonnés
set mouse=                      " Désactive la souris par défaut
set nobackup                    " Désactive les sauvegardes automatiques
set spelllang=fr,en             " Spécifie les langues du dictionnaire

" Permet l'indentation automatique : gg=G
filetype plugin indent on

" Definition des caractères invisibles
let &listchars = "eol:$,space:\u00B7"

" Changement automatique du curseur en fonction du mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Fermeture automatique des brackets
inoremap { {}<Esc>ha
inoremap [ []<Esc>ha

" Mémoriser la dernière position du curseur
autocmd BufReadPost * if (line("'\"") > 1) && (line("'\"") <= line("$")) | silent exe "silent! normal g'\"zO" | endif

" Modification de certaines syntaxes
autocmd BufNewFile,BufRead *.lpl set syntax=json

" Configuration pour tmux
if $TERM == 'tmux-256color'
  set clipboard=unnamedplus
  set mouse=a
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Explorateur de fichiers

" Configuration
let g:netrw_liststyle = 3         " Active le mode Treeview
let g:netrw_sizestyle = "H"       " Active le mode human-readable
let g:netrw_banner = 0            " Désactive la bannière
let g:netrw_browse_split = 4      " Ouvre le fichier choisi dans un panel
let g:netrw_winsize = 15          " Définit la taille de l'explorateur

" Ferme automatiquement l'explorateur
aug netrw_close
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw"|q|endif
aug END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Barre de statut

" Elements à afficher
set statusline+=%F
set statusline+=\ %m
set statusline+=%=
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}
set statusline+=\ \|
set statusline+=\ %P
set statusline+=\ \|
set statusline+=\ %l
set statusline+=\:%c


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapping

" Explorateur de fichiers
nnoremap <F1> :Vexplore<CR>

" Activation de la numérotation
nnoremap <F2> :set number!<CR>

" Correction orthographique (z= pour afficher les propositions)
map <F3> :set spell!<CR>

" Affichage des caractères invisibles
nnoremap <F4> :set list!<CR>

" Indentation automatique
nnoremap <F5> gg=G <CR>

" Souris
nnoremap <F6> :call ToggleMouse()<CR>
function! ToggleMouse()
  if &mouse == 'a'
    set mouse=
    echo "Souris désactivée"
  else
    set mouse=a
    echo "Souris activée"
  endif
endfunction

" Coloration syntaxique
nnoremap <F7> :call ToggleSyntax()<CR>
function! ToggleSyntax()
  if &syntax == ''
    syntax on
    echo "Coloration syntaxique activée"
  else
    syntax off
    set syntax=
    echo "Coloration syntaxique désactivée"
  endif
endfunction

" Changement de document
nnoremap <S-TAB> <C-W>w
nnoremap <TAB> :tabnext<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme

" OneHalfDark
if filereadable("/etc/vim/colors/onehalfdark.vim")
  set cursorline
  set t_Co=256
  colorscheme onehalfdark
  set termguicolors
  set noshowmode
endif
{{< /code >}}

Pour le mapping des touches, voici ce qui est en place grâce à ce fichier :

- F2 : Permet de mettre en couleurs les mots mal orthographiés. La première fois, Vi vous proposera de télécharger les fichiers de langue nécessaires
- F3 : Affiche ou non les numéros de ligne
- F4 : Affiche les caractères de fin de ligne. Pratique si un espace invisible s'est glissé quelque part dans un script
- F5 : Permet d'effectuer une indentation automatique sur l'intégralité du fichier
- F6 : Active / désactive la gestion de la souris. Je ne l'active pas par défaut car la gestion du copier / coller est assez particulière
- F7 : Désactive / active la coloration syntaxique (pour ceux qui sont gênés par les couleurs)

## Le thème OneHalfDark

Vi possède une quantité dingue de thèmes différents. Personnellement, j'utilise le thème [OneHalfDark](https://github.com/sonph/onehalf) :

{{< image src="vi_perso.webp" style="border-radius: 8px;" >}}

Il est disponible sur la plupart des outils d'édition, et sur les terminaux les plus utilisés, dont l'excellent Windows Terminal de Microsoft.

Pour ajouter vos thèmes, il suffit de les déposer ici : `/home/votre_user/.vim/colors` (`mkdir -p $HOME/.vim/colors` si le dossier n'existe pas).

Ayant apporté quelques modifications dessus, je vous partage ma version modifiée directement ici :

{{< code language="vim" title="Fichier onehalfdark.vim" id="2" expand="Afficher" collapse="Cacher" isCollapsed="true" >}}
set background=dark
highlight clear
syntax reset

let g:colors_name="onehalfdark"
let colors_name="onehalfdark"


let s:black       = { "gui": "#282c34", "cterm": "236" }
let s:red         = { "gui": "#e06c75", "cterm": "168" }
let s:green       = { "gui": "#98c379", "cterm": "114" }
let s:yellow      = { "gui": "#e5c07b", "cterm": "180" }
let s:blue        = { "gui": "#61afef", "cterm": "75"  }
let s:purple      = { "gui": "#c678dd", "cterm": "176" }
let s:cyan        = { "gui": "#56b6c2", "cterm": "73"  }
let s:white       = { "gui": "#abb2bf", "cterm": "188" }

let s:fg          = s:white
let s:bg          = s:black

let s:comment_fg  = { "gui": "#636a78", "cterm": "241" }
let s:gutter_bg   = { "gui": "#282c34", "cterm": "236" }
let s:gutter_fg   = { "gui": "#919baa", "cterm": "247" }
let s:non_text    = { "gui": "#373C45", "cterm": "239" }

let s:cursor_line = { "gui": "#313640", "cterm": "237" }
let s:color_col   = { "gui": "#313640", "cterm": "237" }

let s:selection   = { "gui": "#474e5d", "cterm": "239" }
let s:vertsplit   = { "gui": "#313640", "cterm": "237" }


function! s:h(group, fg, bg, attr)
  if type(a:fg) == type({})
    exec "hi " . a:group . " guifg=" . a:fg.gui . " ctermfg=" . a:fg.cterm
  else
    exec "hi " . a:group . " guifg=NONE cterm=NONE"
  endif
  if type(a:bg) == type({})
    exec "hi " . a:group . " guibg=" . a:bg.gui . " ctermbg=" . a:bg.cterm
  else
    exec "hi " . a:group . " guibg=NONE ctermbg=NONE"
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  else
    exec "hi " . a:group . " gui=NONE cterm=NONE"
  endif
endfun


" User interface colors {
call s:h("Normal", s:fg, s:bg, "")

call s:h("Cursor", s:bg, s:blue, "")
call s:h("CursorColumn", "", s:cursor_line, "")
call s:h("CursorLine", "", s:cursor_line, "")

call s:h("LineNr", s:gutter_fg, s:gutter_bg, "")
call s:h("CursorLineNr", s:fg, "", "")

call s:h("DiffAdd", s:green, "", "")
call s:h("DiffChange", s:yellow, "", "")
call s:h("DiffDelete", s:red, "", "")
call s:h("DiffText", s:blue, "", "")

call s:h("IncSearch", s:bg, s:yellow, "")
call s:h("Search", s:bg, s:yellow, "")

call s:h("ErrorMsg", s:fg, "", "")
call s:h("ModeMsg", s:fg, "", "")
call s:h("MoreMsg", s:fg, "", "")
call s:h("WarningMsg", s:red, "", "")
call s:h("Question", s:purple, "", "")

call s:h("Pmenu", s:bg, s:fg, "")
call s:h("PmenuSel", s:fg, s:blue, "")
call s:h("PmenuSbar", "", s:selection, "")
call s:h("PmenuThumb", "", s:fg, "")

call s:h("SpellBad", s:red, "", "")
call s:h("SpellCap", s:yellow, "", "")
call s:h("SpellLocal", s:yellow, "", "")
call s:h("SpellRare", s:yellow, "", "")

call s:h("StatusLine", s:blue, s:cursor_line, "")
call s:h("StatusLineNC", s:comment_fg, s:cursor_line, "")
call s:h("TabLine", s:comment_fg, s:cursor_line, "")
call s:h("TabLineFill", s:comment_fg, s:cursor_line, "")
call s:h("TabLineSel", s:fg, s:bg, "")

call s:h("Visual", "", s:selection, "")
call s:h("VisualNOS", "", s:selection, "")

call s:h("ColorColumn", "", s:color_col, "")
call s:h("Conceal", s:fg, "", "")
call s:h("Directory", s:blue, "", "")
call s:h("VertSplit", s:vertsplit, s:vertsplit, "")
call s:h("Folded", s:fg, "", "")
call s:h("FoldColumn", s:fg, "", "")
call s:h("SignColumn", s:fg, "", "")

call s:h("MatchParen", s:blue, "", "underline")
call s:h("SpecialKey", s:fg, "", "")
call s:h("Title", s:green, "", "")
call s:h("WildMenu", s:fg, "", "")
" }


" Syntax colors {
" Whitespace is defined in Neovim, not Vim.
" See :help hl-Whitespace and :help hl-SpecialKey
call s:h("Whitespace", s:non_text, "", "")
call s:h("NonText", s:non_text, "", "")
call s:h("Comment", s:comment_fg, "", "")
call s:h("Constant", s:cyan, "", "")
call s:h("String", s:green, "", "")
call s:h("Character", s:green, "", "")
call s:h("Number", s:yellow, "", "")
call s:h("Boolean", s:yellow, "", "")
call s:h("Float", s:yellow, "", "")

call s:h("Identifier", s:red, "", "")
call s:h("Function", s:blue, "", "")
call s:h("Statement", s:purple, "", "")

call s:h("Conditional", s:purple, "", "")
call s:h("Repeat", s:purple, "", "")
call s:h("Label", s:purple, "", "")
call s:h("Operator", s:fg, "", "")
call s:h("Keyword", s:red, "", "")
call s:h("Exception", s:purple, "", "")

call s:h("PreProc", s:yellow, "", "")
call s:h("Include", s:purple, "", "")
call s:h("Define", s:purple, "", "")
call s:h("Macro", s:purple, "", "")
call s:h("PreCondit", s:yellow, "", "")

call s:h("Type", s:yellow, "", "")
call s:h("StorageClass", s:yellow, "", "")
call s:h("Structure", s:yellow, "", "")
call s:h("Typedef", s:yellow, "", "")

call s:h("Special", s:blue, "", "")
call s:h("SpecialChar", s:fg, "", "")
call s:h("Tag", s:fg, "", "")
call s:h("Delimiter", s:fg, "", "")
call s:h("SpecialComment", s:fg, "", "")
call s:h("Debug", s:fg, "", "")
call s:h("Underlined", s:fg, "", "")
call s:h("Ignore", s:fg, "", "")
call s:h("Error", s:red, s:gutter_bg, "")
call s:h("Todo", s:purple, "", "")
" }
{{< /code >}}

Le fichier `vimrc` que j'ai mis à disposition plus haut chargera automatiquement ce thème si le fichier `onehalfdark.vim` est présent et que votre terminal est compatible.

## Conclusion

Toutes ces modifications ne sont qu'une porte d'entrée à tout ce qu'il est possible de personnaliser dans Vi. Pour ceux qui souhaiteraient aller encore plus loin, il existe tout un tas de plugins supplémentaires. Mais par expérience, je trouve que cela finit par l'alourdir par rapport à mes besoins.

Si vous avez des questions particulières, vous savez où me trouver :wink:
