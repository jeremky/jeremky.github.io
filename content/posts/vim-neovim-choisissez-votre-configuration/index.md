---
title: "Vim / Neovim : choisissez votre configuration"
date: 2025-03-14T16:29:39.000Z
cover: /posts/vim-neovim-choisissez-votre-configuration/cover.webp
tags:
  - linux
categories:
  - Tutos
toc: true
draft: false
---

Dans [l'article présentant NeoVim](/posts/neovim-un-fork-de-vim-moderne/), je terminais en vous disant que j'attendais une version plus récente dans les dépôts Debian pour avoir une compatibilité avec les derniers plugins optimisés pour la dernière version.

Finalement mon impatience légendaire a eu raison de moi, et j'ai décidé de me créer un script afin d'installer la dernière version de NeoVim à partir des releases officielles sur [Github](https://github.com/neovim/neovim/releases).

Dans cet article, nous allons voir différentes configurations pour Vim et NeoVim, de la plus simple à la plus complexe selon vos besoins, chacune ayant ses avantages et inconvénients.

## L'essentiel : Vim sans plugins

Si vous voulez utiliser Vim en tant qu'éditeur simple, que vous voulez un fichier unique, sans plugins, mais avec tout de même quelques fonctionnalités, ainsi que le thème OneHalfDark, voici le fichier `.vimrc`, à créer dans votre dossier personnel :

```vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration de Vim

" Paramétrage de base
syntax on                       " Active la colorisation syntaxique
set hlsearch                    " Affiche en surbrillance les recherches
set background=dark             " Optimise l'affiche pour un terminal sombre
set laststatus=2                " Affiche en permanence la barre de statut
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
set mouse=                      " Désactive la souris par dÃ©faut
set nobackup                    " Désactive les sauvegardes automatiques
set spelllang=fr,en             " Spécifie les langues du dictionnaire

" Permet l'indentation automatique : gg=G
filetype plugin indent on

" Définition des caractères invisibles
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

" Eléments à afficher
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

" Coloration syntaxique
nnoremap <F4> :call ToggleSyntax()<CR>
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

" Affichage des caractères invisibles
nnoremap <F7> :set list!<CR>

" Changement de document
nnoremap <TAB> :tabnext<CR>
nnoremap <S-TAB> <C-W>w


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme OneHalfDark

set cursorline
set t_Co=256
set termguicolors
set noshowmode
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
```

Ouais... Le fichier est assez costaud, mais cela permet de ne pas être dépendant de fichiers supplémentaires.

A noter que sur certaines distributions, Vim n'est pas nécessairement installé. Pour les distributions basées sur Debian : 

```bash
sudo apt install vim
```

## Un Vim efficace avec plugins

La configuration ci-dessous est celle que j'ai présenté dans l'article sur [NeoVim](/posts/neovim-un-fork-de-vim-moderne/), mais adaptée à Vim. Là encore, collez ce contenu dans un fichier nommé `.vimrc` dans votre dossier personnel :

```Vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration de Vim

" Paramétrage de base
syntax on                       " Active la colorisation syntaxique
set hlsearch                    " Affiche en surbrillance les recherches
set background=dark             " Optimise l'affiche pour un terminal sombre
set laststatus=2                " Affiche en permanence la barre de statut
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
set spelllang=fr,en             " Spécifie les langues du dictionnaire
set viminfofile=~/.vim/.viminfo " Change l'emplacement du fichier viminfo

" Permet l'indentation automatique : gg=G
filetype plugin indent on

" Définition des caractères invisibles
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
" Mapping

" Nerdtree
nnoremap <F1> :NERDTreeToggle <CR>

" Mode IDE
nnoremap <F2> :call ModeIDE() <CR>
function! ModeIDE()
  set number!
  IndentLinesToggle
  GitGutterToggle
endfunction

" Correction orthographique (z= pour afficher les propositions)
map <F3> :set spell!<CR>

" Coloration syntaxique
nnoremap <F4> :call ToggleSyntax()<CR>
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

" Affichage des caractères invisibles
nnoremap <F7> :set list!<CR>

" Changement de document
nnoremap <S-TAB> <C-W>w
nnoremap <TAB> :tabnext<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins

" Téléchargement de vim-plug si introuvable
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Lance automatiquement PlugInstall
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \| PlugInstall --sync | source $MYVIMRC
      \| endif

" Liste des plugins
call plug#begin()

" Theme
Plug 'joshdick/onedark.vim'

" Interface
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'

" Code
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'

" Completion
Plug 'ervandew/supertab'
Plug 'vim-scripts/VimCompletesMe'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

call plug#end()


" Configuration du thème OneDark
if filereadable(expand("~/.vim/plugged/onedark.vim/colors/onedark.vim"))
  let g:onedark_hide_endofbuffer = 1
  let g:onedark_terminal_italics = 0
  colorscheme onedark
  set cursorline
  set termguicolors
endif

" Configuration de LightLine
if filereadable(expand("~/.vim/plugged/lightline.vim/autoload/lightline.vim"))
  set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
  let g:lightline = {'colorscheme': 'onedark'}
  set noshowmode
endif

" Configuration de NERDTree
if filereadable(expand("~/.vim/plugged/nerdtree/autoload/nerdtree.vim"))
  nnoremap <C-o> :NERDTreeToggle <CR>
  let NERDTreeMapOpenInTab='<TAB>'
  let NERDTreeShowHidden=1
  let NERDTreeQuitOnOpen=1
endif

" Configuration de IndentLine
if filereadable(expand("~/.vim/plugged/indentLine/after/plugin/indentLine.vim"))
  let g:indentLine_enabled = 0
  let g:indentLine_char = '▏'
endif

" Configuration de VimCompletesMe
if filereadable(expand("~/.vim/plugged/VimCompletesMe/plugin/VimCompletesMe.vim"))
  autocmd FileType text,markdown let b:vcm_tab_complete = 'dict'
endif

" Configuration de GitGutter
if filereadable(expand("~/.vim/plugged/vim-gitgutter/autoload/gitgutter.vim"))
  nnoremap <C-g> :GitGutterToggle <CR>
  let gitgutter_enabled = 0
endif
```

Via cette configuration, vous disposerez d'une meilleure compréhension du code, un explorateur de fichiers avancé, une gestion de Git, de la complétion...

A noter que pour que cela fonctionne, vous devez avoir curl et git installés : 

```bash
sudo apt install vim curl git
```

Cela permet de télécharger le gestionnaire de plugins et les plugins listés dans le fichier de configuration automatiquement au 1er démarrage. Donc pas besoin de fichiers suplémentaires.

## NeoVim : Vim en mode IDE

Afin de profiter de plugins modernes écrits en Lua, il est nécessaire de disposer de la dernière version de NeoVim. Elle n'est malheureusement pas disponible dans les dépôts Debian, nous allons donc devoir l'installer "à l'ancienne".

### Installation de NeoVim

Pour l'installer, je vous ai préparé un petit script bash. Ce dernier va télécharger le binaire dans sa dernière version (selon votre architecture), va ajouter le lien dans votre variable `PATH` afin de l'appeler directement avec la commande `nvim`, et va également installer la distribution [LazyVim](https://www.lazyvim.org/).

Vous trouverez le script d'installation en suivant [ce lien](/files/vim-neovim-choisissez-votre-configuration/nviminstall.tar.gz).

Décompressez le fichier via la commande suivante : 

```bash
tar xzf nviminstall.tar.gz
```

Exécutez ensuite le script : 

```bash
./nviminstall.sh
```

Votre mot de passe vous sera demandé pour exécuter `apt`, afin d'installer les binaires nécessaires pour une meilleure expérience.

### LazyVim ?

[LazyVim](https://www.lazyvim.org/) fait partie des nombreuses "distributions" existantes pour NeoVim. Voyez cela comme une préconfiguration de NeoVim, avec gestionnaire de plugins avancé et quelques éléments déjà paramétrés.

La configuration initiale est déjà excellente, mais il est possibles d'ajouter ses préférences de réglage, de mapping des touches, un thème différent etc...

Les modifications que j'ai effectué sont disponibles et seront installées directement via le script [nviminstall.sh](/files/vim-neovim-choisissez-votre-configuration/nviminstall.tar.gz).

Dans les modifications apportées, il y a le changement du thème par [Catppuccin](https://catppuccin.com/) macchiato, l'ajout de mon mapping des touches F2 à F7, et une désactivation de plugins que je ne trouve pas nécessaires. Libre à vous de partir de cette base pour faire vos changements.

> Le thème OneDark ne sera plus utilisé. Je ferai un article dédié au sujet du remplacement de mon thème par Catppuccin

### Des icônes ?

Les plugins pour la barre de statut et pour l'explorateur de fichiers utilisent des polices avancées, afin d'afficher de belles icônes dans votre terminal.

Rendez-vous sur le site [Nerd Font](https://www.nerdfonts.com/font-downloads) pour y télécharger la police qui vous convient, puis appliquez la sur votre terminal. Perso, j'ai opté pour la police `JetBrainsMono Nerd Font`.

### Résultat

Une fois tout en place, NeoVim peut de venir un véritable IDE performant. Outil de recherche, compréhension du code, complétion avancée, aperçu des modifications git en temps réel, terminal intégré... 

Un petit aperçu du résultat : 

{{< image src="dashboard.webp" style="border-radius: 8px;" >}}

{{< image src="find.webp" style="border-radius: 8px;" >}}

{{< image src="completion.webp" style="border-radius: 8px;" >}}

## Conclusion

Ok, c'était finalement assez dense comme article. Mais vous avez maintenant le choix : 
- Un simple éditeur de texte avec un fichier unique
- Un éditeur de texte complet, sans se prendre la tête pour l'installation et la configuration 
- Un IDE ultra performant dans votre terminal

Perso, j'ai combiné les options 2 et 3 : un Vim simple mais avec quelques fonctionnaliés sympa pour l'édition de fichiers système et un NeoVim hyper complet pour l'écriture de scripts.

Mais je garde l'option 1 sous le coude : elle a le mérite d'être simple à déposer sur certaines machines sans avoir besoin d'y ajouter de dépendances.

A vous de tester et de faire votre choix selon ce qui vous convient le mieux !
