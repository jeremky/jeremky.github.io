---
title: Configuration du thème Catppuccin
slug: configuration-du-theme-catppuccin
date: 2025-03-27T21:18:43+01:00
useRelativeCover: true
cover: cover.webp
tags:
  - linux
categories:
  - Tutos
toc: true
draft: false
---

Dans les différents articles au sujet d'applications pour terminal, j'utilisais l'excellent thème OneDark. Mais je me suis dit qu'il était temps de changer et de passer à un nouveau thème : [Catppuccin](https://catppuccin.com/).

Catppuccin fait partie des thèmes hyper complets, disponibles sur une grande liste d'applications diverses, comme des IDE, des terminaux, des navigateurs Web, etc...

Je vais donc dans cet article vous partager mes configurations sur les applications qui nécessitent un peu d'huile de coude pour procéder à son installation. A noter que Catppuccin propose 4 variantes, 1 claire et 3 sombres : 
- Latte
- Frappé
- Macchiato
- Mocha

J'ai fait le choix de la variante Macchiato. A vous d'adapter les configurations ci dessous selon vos préférences.

## Applications

Catppuccin propose sur [son site](https://catppuccin.com/ports/) un outil pour rechercher directement par application. Vous serez redirigé vers le projet GitHub concerné avec la procédure pour l'installation du thème.

{{< image src="app.webp" style="border-radius: 8px;" >}}

Je vous propose donc d'installer le thème pour le terminal que vous utilisez. Les principaux y sont : [Windows Terminal](https://github.com/catppuccin/windows-terminal), [iTerm2](https://github.com/catppuccin/iterm), [Gnome Terminal](https://github.com/catppuccin/gnome-terminal)...

## Bash

Maintenant que votre terminal dispose des couleurs de Catppuccin, nous allons adapter certaines applications cli pour être en phase avec le thème. Dans mon cas, cela concerne 2 applications : [fzf](https://github.com/junegunn/fzf), et [tmux](https://github.com/tmux/tmux/wiki).

### fzf

Si vous n'avez pas encore installé fzf, je vous le recommande. Fzf permet entre autre d'améliorer la recherche dans l'historique via le raccourci `ctrl + r`.

Pour l'installer : 

```bash
sudo apt install fzf
```

Pour configurer ses couleurs, ajoutez les lignes suivantes dans votre fichier `.bashrc` ou `.bash_aliases` :

```bash
if [[ -f /usr/bin/fzf ]]; then
  eval "$(fzf --bash)"
  export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=border:#363a4f,label:#cad3f5"
fi
```

### tmux

Là encore, si vous ne connaissez pas tmux, je vous recommande d'aller consulter [l'article qui lui est dédié](/posts/tmux-multiplexeur-de-terminaux/).

Pour tmux, n'utilisant pas toutes les fonctionnalités proposées, je vous mets à dispo [cette archive](/files/tmux.tar.gz) contenant le nécessaire à extraire dans `~/.config/tmux`. Cette version se contente des couleurs, et de l'affichage du load average dans la barre de statut.

{{< image src="tmux.webp" style="border-radius: 8px;" >}}

## Btop

[Btop](https://github.com/aristocratos/btop) est un moniteur de ressources système. Par habitude, j'ai toujours une préférence pour htop. Mais puisque le thème Catppuccin existe aussi pour lui, je vous le partage [ici](/files/btop.tar.gz). 

{{< image src="btop.webp" style="border-radius: 8px;" >}}

## Vim

Pour Vim, 2 options : 

- Utiliser le gestionnaire de plugins vim-plug
- Ajouter manuellement le thème

### Via plugin

La ligne à ajouter pour vim-plug est la suivante : 

```vim
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
```

Ensuite, à la fin de votre fichier `.vimrc` :

```vim
" Configuration du theme Catppuccin
if filereadable(expand("~/.vim/plugged/catppuccin/colors/catppuccin_macchiato.vim"))
  colorscheme catppuccin_macchiato
  set cursorline
  set termguicolors
endif

" Configuration de LightLine
if filereadable(expand("~/.vim/plugged/lightline.vim/autoload/lightline.vim"))
  set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
  let g:lightline = {'colorscheme': 'catppuccin_macchiato'}
  set noshowmode
endif
```

Pensez à retirer le thème OneDark si vous êtes parti [de cet article](/posts/vim-neovim-choisissez-votre-configuration/#un-vim-efficace-avec-plugins), ou bien récupérez le fichier à jour directement [ici](https://github.com/jeremky/envbackup/blob/main/dotfiles/debian/.vimrc).

{{< image src="vim.webp" style="border-radius: 8px;" >}}

### Manuellement

Si vous préférez utiliser Vim sans plugin, récupérez le fichier [suivant](https://github.com/catppuccin/vim/blob/main/colors/catppuccin_macchiato.vim), et déposez le dans `~/.vim/colors/catppuccin.vim`.

Chargez ensuite le thème dans votre fichier `.vimrc` :

```vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme Catppuccin

if filereadable(expand("~/.vim/colors/catppuccin.vim"))
  set cursorline
  set t_Co=256
  set termguicolors
  set noshowmode
  highlight clear
  syntax reset
  colorscheme catppuccin
endif
```

Le rendu est le même qu'avec la version plugin, sauf la barre de statut (puisque Lightline n'est pas installé) : 

{{< image src="vim2.webp" style="border-radius: 8px;" >}}

## Neovim

Si vous avez suivi [cet article](/posts/vim-neovim-choisissez-votre-configuration/#neovim--vim-en-mode-ide), vous n'avez rien à faire. Catppuccin Macchiato est déjà configuré dans les fichiers que je vous ai mis à disposition.

Si toutefois vous utilisez une autre variante, modifiez le fichier `~/.config/nvim/lua/plugins/colorscheme.lua` en fonction.

{{< image src="neovim.webp" style="border-radius: 8px;" >}}

## Conclusion

Catppuccin fait partie de ces packs de thèmes vraiment complets si vous voulez uniformiser le style de vos applications. Les autres logiciels que j'utilise avec ce thème l'intègrent parfois directement, ou alors via une simple extension à installer, comme Visual Studio Code ou Firefox (Pour Visual Studio Code, pensez à installer aussi le pack d'icônes).

D'autres thèmes de cette envergure existent. Je peux vous citer par exemple [Dracula](https://draculatheme.com/) et [Nord](https://www.nordtheme.com/). Mais Catppuccin utilise une palette vraiment plaisante, permettant une lecture du code efficace.
