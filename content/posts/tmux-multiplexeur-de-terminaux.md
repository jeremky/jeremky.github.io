---
title: "tmux : multiplexeur de terminaux"
date: 2025-01-22T22:06:43.470Z
cover: /img/posts/tmux-multiplexeur-de-terminaux/cover.webp
tags:
  - linux
categories:
  - Tutos
toc: true
draft: false
---

[tmux](https://fr.wikipedia.org/wiki/Tmux) est un multiplexeur de terminaux libre en mode texte. Il permet d'utiliser plusieurs terminaux virtuels dans une seule fenêtre de terminal ou une session sur un terminal distant. tmux peut être détaché d'une session et continuer de fonctionner en arrière-plan, on peut également s'y rattacher plus tard. Il permet aussi de lancer, de gérer et de garder le visuel sur plusieurs processus en même temps.

Même si les émulateurs de terminaux modernes permettent diviser les fenêtres, il faut réapprendre les raccourcis clavier de ces applications. tmux permet d'unifier ses méthodes de travail, et de récupérer ses sessions en cas de coupure réseau par exemple.

## Installation

tmux est généralement présent dans les dépôts officiels de votre distribution préférée. Dans le cas de Debian/Ubuntu :

```bash
sudo apt install tmux
```

Je vous conseille d'ajouter à votre fichier `.bash_aliases` un alias, afin de ne pas vous retrouver avec une multitude de processus tmux :

```bash
# tmux : émulateur de terminal
if [ -f /usr/bin/tmux ] ; then
  alias tmux='tmux attach || tmux new'
fi
```

De cette manière, il vous suffit de taper `tmux` pour se rattacher au dernier tmux ouvert, ou de créer une nouvelle sessions si aucun tmux n'est trouvé.

## Fichier de configuration

Au lancement de tmux, ce dernier va charger un fichier de configuration si présent à l'un de ces emplacements :
- soit dans `~/.tmux.conf`
- soit dans `~./.config/tmux/tmux.conf`

Je vous partage ici mon fichier de configuration, afin d'avoir une base des possibilités que je vous laisse adapter selon vos préférences :

```txt
##################################################################
## Configuration de Tmux

# Forcer les couleurs modernes
set -ga terminal-overrides ",*256col*:Tc"

# Diminuer le temps d'échappement
set -g escape-time 10

# Changement du compteur
set -g base-index 1
setw -g pane-base-index 1

# Temps d'affichage des messages
set -g display-time 3000

# Historique défilable plus long
set -g history-limit 10000

# Séparateur de fenêtres
set-option -wg window-status-separator "|"

# Surveiller les changer dans les fenêtres
set-option -wg monitor-activity on
set-option -wg monitor-bell on

# Fréquence de mise à jour de la barre de statut
set-option -g status-interval 10

# Longueur de la barre de statut
set -g status-right-length 100

# Activation de la souris
set -g mouse on

# Renomme les fenêtres automatiquement
set -g renumber-windows on


##################################################################
## Mapping

# Changement du prefix
unbind C-b
set-option -g prefix C-z
set-option -g prefix2 C-Space

# Changement du raccourci pour coller
bind -n C-v paste-buffer

# Changement des raccourcis pour split
bind -n C-w split-window -v -c "#{pane_current_path}"
bind -n C-x split-window -h -c "#{pane_current_path}"

# Changement des raccourcis pour changer de fenêtre
bind -n C-n next-window
bind -n C-p previous-window

# Synchroniser les panneaux
bind S setw synchronize-panes on
bind s setw synchronize-panes off

# Se déplacer entre les panneaux
bind -n C-Left select-pane -L
bind -n C-Right select-pane -R
bind -n C-Up select-pane -U
bind -n C-Down select-pane -D

# Redimensionner les panneaux
bind -n M-Left resize-pane -L 5
bind -n M-Right resize-pane -R 5
bind -n M-Up resize-pane -U 5
bind -n M-Down resize-pane -D 5


##################################################################
## Configuration du theme

# Couleur de la fenêtre
set-option -wg mode-style bg="#98c379",fg="#2c323c"

# Couleur de la barre de statut
set-option -g status-style bg="#2c323c",fg="#868d9b"

# Couleur des fenêtres par défaut dans la barre de statut
set-option -wg window-status-style bg="#2c323c",fg="#868d9b"

# Couleur des fenêtres avec activité dans la barre de statut
set-option -wg window-status-activity-style bg="#2c323c",fg="#5da5e1"

# Couleur des fenêtres avec alerte dans la barre de statut
set-option -wg window-status-bell-style bg="#e06c75",fg="#2c323c"

# Couleur du titre de la fenêtre active dans la barre de statut
set-option -wg window-status-current-style bg="#98c379",fg="#2c323c"

# Couleurs des panneaux
set-option -g pane-active-border-style fg="#98c379"
set-option -g pane-border-style fg="#3f4452"

# Couleur des messages d'info
set-option -g message-style bg="#5da5e1",fg="#2c323c"

# Couleur des messages de commande
set-option -g message-command-style bg="#5d677a",fg="#2c323c"

# Couleurs du Numéro de panneau
set-option -g display-panes-active-colour "#98c379"
set-option -g display-panes-colour "#2c323c"

# Couleur de l'horloge
set-option -wg clock-mode-colour "#98c379"

# Couleur de surbrillance du mode copy
set-option -wg copy-mode-match-style "bg=#5d677a,fg=#2c323c"
set-option -wg copy-mode-current-match-style "bg=#5da5e1,fg=#2c323c"


##################################################################
## Eléments de la barre de statut

# Etat de tmux
set-option -g status-left "#{?client_prefix,#[bg=#5da5e1],#[bg=#5d677a]}#[fg=#2c323c] # "

# Affichage du load average linux
set-option -g status-right "#(uptime | awk -F'load average:' '{ print $2 }') #{?client_prefix,#[bg=#5da5e1],#[bg=#5d677a]}#[fg=#2c323c] #{session_name} "

# Apparence des fenêtres actives
set-option -wg window-status-current-format "#{?window_zoomed_flag,#[fg=default bold],#[fg=default]} #{window_index} #{window_name} "

# Apparence des fenêtres non actives
set-option -wg window-status-format "#{?window_zoomed_flag,#[fg=default bold],#[fg=default]} #{window_index} #{window_name} "
```

> Pour rappel, je mets à disposition mes fichiers de configuration sur [GitHub](https://github.com/jeremky/envbackup). Vous pouvez récupérer le fichier `tmux.conf` [directement ici](https://github.com/jeremky/envbackup/blob/main/dotfiles/.config/tmux/tmux.conf).

Ce fichier de configuration ajoute les fonctionnalités suivantes : 

- Prise en charge de la souris
- Couleurs inspirées du thème OneDark
- Affichage du Load Average Linux dans la barre d'état
- Changement de divers raccourcis clavier

## Utilisation

> Cette section est rédigée en considérant que vous avez suivi les étapes d'installation de cet article.

Voici les quelques raccourcis que j'utilise principalement :

| Raccourcis | Fonction |
| -------- | ------- |
| Ctrl + x       | Split verticalement l'écran |
| Ctrl + w       | Split horizontalement l'écran |
| Ctrl + z       | Active le mode Préfixe de tmux |
| Ctrl + z, c    | Créé un nouvel onglet |
| Ctrl + n       | Onglet suivant |
| Ctrl + p       | Onglet précédent |
| Ctrl + z, S    | Synchronise la saisie dans tous les panneaux |
| Ctrl + z, s    | Désactive la synchronisation de la saisie |
| Ctrl + v       | Coller la selection |
| Ctrl + z, t    | Affiche une horloge |
| Ctrl + Flèches | naviguer entre les panneaux |
| Alt + Flèches  | Ajuster la taille des panneaux |

Vous pouvez également utiliser le clic droit de la souris pour créer des panneaux, ou changer d'onglet.

Pour finir cet article, voici un petit exemple de rendu : 

{{< image src="/img/posts/tmux-multiplexeur-de-terminaux/tmux.webp" style="border-radius: 8px;" >}}