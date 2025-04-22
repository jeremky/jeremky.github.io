---
title: "Neovim : un fork de Vim moderne"
slug: neovim-un-fork-de-vim-moderne
date: 2025-01-25T19:41:07.554Z
useRelativeCover: true
cover: cover.webp
tags:
  - linux
categories:
  - Tutos
toc: true
draft: false
---

Je vous avais présenté mon éditeur en mode terminal favoris, Vim. Dans [cet article](/posts/vi-na-pas-dit-son-dernier-mot/), j'indiquais que je ne voulais pas dépendre de plugins additionnels... Mais mon regard à changé depuis. Et quitte à refaire une configuration complète, je me suis dit qu'il était temps de passer à Neovim.

[Neovim](https://neovim.io/) est un fork qui vise à améliorer l'extensibilité et la maintenabilité de Vim. Neovim partage la même syntaxe de configuration avec Vim ; par conséquent, le même fichier de configuration peut être utilisé avec les deux éditeurs (à quelques différences près). À partir de la version 0.1, sortie en décembre 2015, Neovim est compatible avec la quasi-totalité des fonctionnalités de Vim.

## Pourquoi passer à Neovim ?

Le principal argument mis en avant par la communauté, c'est la compatibilité avec le langage [Lua](https://fr.wikipedia.org/wiki/Lua) pour le développement de scripts. Mais ce que je vais vous présenter dans la suite de cet article va se contenter d'utiliser des plugins développés à l'origine pour Vim. Alors pourquoi utiliser Neovim plutôt que Vim ?

- Il est mieux optimisé, et cela se ressent au démarrage et à l'utilisation de l'éditeur
- Contrairement à Vim, il respecte les derniers standards Linux pour les emplacements de fichiers de configuration (centralisation des fichiers de configuration dans `.config`, `.local`, etc...)
- Certains plugins suivent les dernières versions de Neovim, ce qui les rendent incompatibles avec la version présente dans certaines distributions, comme Debian

## Installation

Neovim est généralement présent dans les dépôts officiels de votre distribution préférée. Dans le cas de Debian/Ubuntu :

```bash
sudo apt install neovim
```

Je vous conseille d'ajouter à votre fichier `.bash_aliases` un alias, afin de faire pointer la commande `vi` vers `nvim` ou `vim` selon l'éditeur installé :

```bash
# vim : Vi amélioré
if [ -f /usr/bin/nvim ] ; then
  alias vi='nvim -nO'
elif [ -f /usr/bin/vim ] ; then
  alias vi='vim -nO'
fi
```

## Fichier de configuration

Comme pour Vim, je vous partage ici une configuration dans un fichier unique. Ce fichier sera à placer ici : `~./.config/nvim/init.vim`.

{< code language="vim" title="Fichier init.vim" id="1" expand="Afficher" collapse="Cacher" isCollapsed="true" >}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration de Neovim

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
  echo "Mode IDE"
endfunction

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

" Réduction du code
nnoremap <F8> :call ToggleFold()<CR>
function! ToggleFold()
  if &foldmethod == 'indent'
    set foldmethod=syntax
    echo "Mode Fold désactivé"
  else
    set foldmethod=indent
    set foldlevel=1
    set foldclose=all
    echo "Mode Fold activé"
  endif
endfunction

" Changement de document
nnoremap <TAB> :tabnext<CR>
nnoremap <S-TAB> <C-W>w


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins

" Téléchargement de vim-plug si introuvable
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
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
"Plug 'ryanoasis/vim-devicons'
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
if filereadable(expand("~/.local/share/nvim/plugged/onedark.vim/colors/onedark.vim"))
  let g:onedark_hide_endofbuffer = 1
  let g:onedark_terminal_italics = 0
  colorscheme onedark
  set cursorline
  set termguicolors
endif

" Configuration de LightLine
if filereadable(expand("~/.local/share/nvim/plugged/lightline.vim/autoload/lightline.vim"))
  set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
  let g:lightline = {'colorscheme': 'onedark'}
  set noshowmode
endif

" Configuration de NERDTree
if filereadable(expand("~/.local/share/nvim/plugged/nerdtree/autoload/nerdtree.vim"))
  nnoremap <C-o> :NERDTreeToggle <CR>
  let NERDTreeMapOpenInTab='<TAB>'
  let NERDTreeShowHidden=1
  let NERDTreeQuitOnOpen=1
endif

" Configuration de IndentLine
if filereadable(expand("~/.local/share/nvim/plugged/indentLine/after/plugin/indentLine.vim"))
  let g:indentLine_enabled = 0
  let g:indentLine_char = '▏'
endif

" Configuration de VimCompletesMe
if filereadable(expand("~/.local/share/nvim/plugged/VimCompletesMe/plugin/VimCompletesMe.vim"))
  autocmd FileType text,markdown let b:vcm_tab_complete = 'dict'
endif

" Configuration de GitGutter
if filereadable(expand("~/.local/share/nvim/plugged/vim-gitgutter/autoload/gitgutter.vim"))
  nnoremap <C-g> :GitGutterToggle <CR>
  let gitgutter_enabled = 0
endif
{{< /code >}}

Le fichier est divisé en plusieurs sections : 

- Les paramétrages de base de Neovim
- Les raccourcis clavier
- La gestion des plugins

Pour les 2 premières sections, vous pouvez vous référer à l'article sur [Vi](/posts/vi-na-pas-dit-son-dernier-mot/), les configurations sont sensiblement les mêmes.

> Un dernier point tout de même au sujet de Vim. Les articles présents à son sujet sur ce site ont été adaptés pour vous laisser une version disponible de mon fichier de configuration d'origine si jamais vous ne voulez pas utililser Neovim.

## Plugins

La configuration proposée ci-dessus permet d'automatiquement effectuer les opérations suivantes : 

- Installer le gestionnaire de plugins [vim-plug](https://github.com/junegunn/vim-plug)
- Lancer l'installation des plugins non présents
- Configurer les plugins au démarrage

Les plugins que j'utilise sont les suivants :

- Le thème [OneDark](https://github.com/joshdick/onedark.vim)
- L'ajout d'icônes via [vim-devicons](https://github.com/ryanoasis/vim-devicons) (à activer une fois votre police [Nerd Fonts](https://www.nerdfonts.com/) installée)
- La barre de statut [Lightline](https://github.com/itchyny/lightline.vim)
- L'explorateur de fichiers [NERDTree](https://github.com/preservim/nerdtree)
- L'affichage de l'indentation avec [IndentLine](https://github.com/Yggdroot/indentLine)
- Meilleure coloration du code via [vim-polyglot](https://github.com/sheerun/vim-polyglot)
- L'auto complétion via [Supertab](https://github.com/ervandew/supertab)
- Pour faire de l'auto complétion avec des éléments présents dans le fichier, [VimCompletesMe](https://github.com/vim-scripts/VimCompletesMe)
- Utiliser les commandes Git dans l'éditeur, avec [Fugitive](https://github.com/tpope/vim-fugitive)
- Comparaison Git, avec [vim-gitgutter](https://github.com/airblade/vim-gitgutter)

Voici un petit aperçu du résultat : 

{{< image src="nvim.webp" style="border-radius: 8px;" >}}

Petite info pour finir, il est à noter que mon utilisation des plugins Vim dans Neovim n'est que temporaire. Debian 13 proposera une version plus récente de Neovim, je referai donc un article à ce moment là pour vous proposer des plugins écris spécifiquement pour Neovim.
