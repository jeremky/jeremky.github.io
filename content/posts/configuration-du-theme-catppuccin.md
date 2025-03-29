---
title: "Configuration du thème Catppuccin"
date: 2025-03-27T21:18:43+01:00
cover: "/img/posts/configuration-du-theme-catppuccin/cover.webp"
tags:
  - linux
categories:
  - Tutos
toc: true
draft: true
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

{{< image src="/img/posts/configuration-du-theme-catppuccin/app.webp" style="border-radius: 8px;" >}}

Je vous propose donc d'installer le thème pour le terminal que vous utilisez. Les principaux y sont : [Windows Terminal](https://github.com/catppuccin/windows-terminal), [iTerm2](https://github.com/catppuccin/iterm), [Gnome Terminal](https://github.com/catppuccin/gnome-terminal)...

## Bash

Certaines applications cli peuvent être personnalisées au niveau des couleurs utilisées. Dans mon cas, cela concerne 2 applications : [fzf](https://github.com/junegunn/fzf), et [tmux](https://github.com/tmux/tmux/wiki).

### fzf

Pour configurer les couleurs de fzf, ajoutez les lignes suivantes dans votre fichier `.bashrc` ou `.bash_aliases` :

```bash
if [[ -f /usr/bin/fzf ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
  export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=border:#363a4f,label:#cad3f5"
fi
```

> fzf permet entre autre d'améliorer la recherche dans l'historique via le raccourci `ctrl + r`

### tmux

Pour tmux, n'utilisant pas toutes les fonctionnalités proposées, je vous mets à dispo [cette archive](/files/configuration-du-theme-catppuccin/tmux.tar.gz) contenant le nécessaire à déposer dans `~/.config/tmux`. Le résultat : 

{{< image src="/img/posts/configuration-du-theme-catppuccin/tmux.webp" style="border-radius: 8px;" >}}

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
```

Pensez à retirer le thème OneDark si vous êtes parti [de cet article](https://jeremky.github.io/posts/vim-neovim-choisissez-votre-configuration/#un-vim-efficace-avec-plugins), ou bien récupérez le fichier à jour directement [ici](https://github.com/jeremky/envbackup/blob/main/dotfiles/.vimrc).

{{< image src="/img/posts/configuration-du-theme-catppuccin/vim.webp" style="border-radius: 8px;" >}}

### Manuellement

Si vous préférez utiliser Vim sans plugin, récupérez le fichier [suivant](https://github.com/catppuccin/vim/blob/main/colors/catppuccin_macchiato.vim), et déposez le dans `~/.vim/colors/catppuccin.vim`.

Chargez ensuite le thème dans votre fichier `.vimrc` :

```vim
colorscheme catppuccin
```

## NeoVim

Si vous avez suivi [cet article](https://jeremky.github.io/posts/vim-neovim-choisissez-votre-configuration/#neovim--vim-en-mode-ide), vous n'avez rien à faire. Catppuccin Macchiato est déjà configuré dans les fichiers que je vous ai mis à disposition.

{{< image src="/img/posts/configuration-du-theme-catppuccin/neovim.webp" style="border-radius: 8px;" >}}

## Conclusion

Catppuccin fait partie de ces packs de thèmes vraiment complets si vous voulez uniformiser le style de vos applications. Les autres logiciels que j'utilise avec ce thème intègrent même ce thème directement, ou alors via une simple extension à installer (comme Visual Studio Code ou Firefox).

D'autres thèmes de cette envergure existent. Je peux vous citer par exemple [Dracula](https://draculatheme.com/) et [Nord](https://www.nordtheme.com/). Mais Catppuccin utilise une palette vraiment plaisante, notamment pour la lecture de code.