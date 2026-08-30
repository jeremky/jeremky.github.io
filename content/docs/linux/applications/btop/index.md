---
title: "btop"
slug: btop
contextMenu: true
weight: 33
toc: true
tags:
  - linux
draft: true
lastmod: 2026-08-30
---

[btop](https://github.com/aristocratos/btop) (aussi appelé btop++) est un moniteur de ressources système pour le terminal. Il affiche en temps réel le CPU, la mémoire, les disques, le réseau et les processus dans une interface colorée, réactive et entièrement pilotable à la souris.

## Installation

| Distribution  | Commande                |
| ------------- | ----------------------- |
| Debian/Ubuntu | `sudo apt install btop` |
| Fedora        | `sudo dnf install btop` |

> [!IMPORTANT]
> btop nécessite Debian 12 / Ubuntu 22.04 ou une version plus récente. Sur des versions antérieures, il faut passer par les backports ou compiler depuis les [sources](https://github.com/aristocratos/btop#compilation)

## Utilisation

### Lancer btop

```bash
btop
```

### Options en ligne de commande

| Option                    | Description                                    |
| ------------------------- | ---------------------------------------------- |
| `-c`, `--config <file>`   | Utilise un fichier de configuration spécifique |
| `-d`, `--debug`           | Active le mode debug (logs supplémentaires)    |
| `-f`, `--filter <filter>` | Définit un filtre de processus au démarrage    |
| `--force-utf`             | Force l'utilisation de l'UTF-8                 |
| `-l`, `--low-color`       | Limite l'affichage à 256 couleurs              |
| `-t`, `--tty`             | Force le mode TTY (couleurs limitées)          |
| `-u`, `--update <ms>`     | Définit l'intervalle de rafraîchissement (ms)  |

## Raccourcis clavier

| Raccourci          | Action                                                  |
| ------------------ | ------------------------------------------------------- |
| `Esc`, `m`         | Afficher/masquer le menu principal                      |
| `F1`, `?`, `h`     | Afficher l'aide                                         |
| `F2`, `o`          | Afficher les options                                    |
| `p`                | Preset de vue suivant                                   |
| `Shift + p`        | Preset de vue précédent                                 |
| `1`                | Afficher/masquer la boîte CPU                           |
| `2`                | Afficher/masquer la boîte MEM                           |
| `3`                | Afficher/masquer la boîte NET                           |
| `4`                | Afficher/masquer la boîte PROC                          |
| `5`                | Afficher/masquer la boîte GPU                           |
| `d`                | Afficher/masquer la vue disques dans la boîte MEM       |
| `+`, `-`           | Ajuster l'intervalle de rafraîchissement (±100 ms)      |
| `Ctrl + z`         | Mettre le programme en pause et en arrière-plan         |
| `Ctrl + r`         | Recharger la configuration depuis le disque             |
| `q`, `Ctrl + c`    | Quitter                                                 |
| `↑`, `↓`           | Sélectionner un processus dans la liste                 |
| `Entrée`           | Afficher les infos détaillées du processus sélectionné  |
| `Espace`           | Étendre/réduire le processus sélectionné (vue arbo)     |
| `C`                | Étendre/réduire les enfants du processus sélectionné    |
| `Pg Up`, `Pg Down` | Se déplacer d'une page dans la liste des processus      |
| `Home`, `End`      | Aller au début/à la fin de la liste des processus       |
| `←`, `→`           | Changer la colonne de tri                               |
| `f`, `/`           | Filtrer les processus (`!` en préfixe pour une regex)   |
| `F`                | Suivre le processus sélectionné                         |
| `u`                | Mettre en pause la liste des processus                  |
| `Suppr`            | Effacer le filtre en cours                              |
| `c`                | Afficher l'usage CPU par cœur pour les processus        |
| `r`                | Inverser l'ordre de tri                                 |
| `e`                | Basculer la vue arborescente des processus              |
| `E`                | Étendre/réduire tous les processus (vue arbo)           |
| `%`                | Changer le mode d'affichage de la mémoire               |
| `t` _(sélection)_  | Terminer le processus (SIGTERM)                         |
| `k` _(sélection)_  | Tuer le processus (SIGKILL)                             |
| `s` _(sélection)_  | Choisir et envoyer un signal au processus               |
| `N` _(sélection)_  | Changer la valeur nice du processus                     |
| `b`, `n`           | Sélectionner l'interface réseau précédente/suivante     |
| `i`                | Basculer le mode disques I/O avec grands graphiques     |
| `a`                | Basculer l'auto-scaling des graphiques réseau           |
| `y`                | Basculer le mode d'échelle synchronisée (réseau)        |
| `z`                | Réinitialiser les totaux de l'interface réseau courante |

## Configuration

Fichier de configuration :

```vim {filename=".config/btop/btop.conf"}
#? Config file for btop v.1.4.7

#* Theme name.
color_theme = "catppuccin"

#* Theme background.
theme_background = true

#* 24-bit color.
truecolor = true

#* Force TTY mode.
force_tty = false

#* Disable presets.
disable_presets = "Off"

#* Box layout presets.
presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty"

#* Vim navigation keys.
vim_keys = false

#* Disable mouse.
disable_mouse = false

#* Rounded corners.
rounded_corners = true

#* Sync terminal output.
terminal_sync = true

#* Graph symbol.
graph_symbol = "block"

#* Cpu graph symbol.
graph_symbol_cpu = "default"

#* Mem graph symbol.
graph_symbol_mem = "default"

#* Net graph symbol.
graph_symbol_net = "default"

#* Proc graph symbol.
graph_symbol_proc = "default"

#* Boxes shown.
shown_boxes = "cpu mem net proc"

#* Update interval (ms).
update_ms = 2000

#* Process sort order.
proc_sorting = "cpu lazy"

#* Reverse sort.
proc_reversed = false

#* Tree view.
proc_tree = false

#* Cpu-colored process list.
proc_colors = true

#* Gradient in process list.
proc_gradient = true

#* Per-core cpu usage.
proc_per_core = false

#* Memory as bytes.
proc_mem_bytes = true

#* Per-process cpu graph.
proc_cpu_graphs = true

#* Smaps-based memory info.
proc_info_smaps = false

#* Proc box on the left.
proc_left = false

#* Filter kernel processes.
proc_filter_kernel = false

#* Follow selected process.
proc_follow_detailed = true

#* Aggregate child resources in tree.
proc_aggregate = false

#* Keep dead process usage.
keep_dead_proc_usage = false

#* Upper cpu graph stat.
cpu_graph_upper = "Auto"

#* Lower cpu graph stat.
cpu_graph_lower = "Auto"

#* Invert lower cpu graph.
cpu_invert_lower = true

#* Disable lower cpu graph.
cpu_single_graph = false

#* Cpu box at the bottom.
cpu_bottom = false

#* Show uptime.
show_uptime = true

#* Show cpu watts.
show_cpu_watts = true

#* Show cpu temperature.
check_temp = true

#* Temperature sensor.
cpu_sensor = "Auto"

#* Per-core temperatures.
show_coretemp = true

#* Fix mismapped core temps.
cpu_core_map = ""

#* Temperature scale.
temp_scale = "celsius"

#* Base 10 sizes.
base_10_sizes = false

#* Show cpu frequency.
show_cpu_freq = true

#* Cpu frequency calc mode.
freq_mode = "first"

#* Clock format (strftime).
clock_format = "%X"

#* Update UI behind open menus.
background_update = true

#* Custom cpu name.
custom_cpu_name = ""

#* Disk filter.
disks_filter = ""

#* Memory as graphs.
mem_graphs = true

#* Mem box below net box.
mem_below_net = false

#* Count ZFS ARC as cached.
zfs_arc_cached = true

#* Show swap.
show_swap = true

#* Swap as a disk.
swap_disk = true

#* Show disks in mem box.
show_disks = true

#* Physical disks only.
only_physical = true

#* Read disks from fstab.
use_fstab = true

#* Hide ZFS datasets.
zfs_hide_datasets = false

#* Free space for privileged users.
disk_free_priv = false

#* Show disk busy %.
show_io_stat = true

#* IO graph mode.
io_mode = false

#* Combine io graphs.
io_graph_combined = false

#* Swap up/down graph positions.
swap_upload_download = false

#* Auto-scale net graphs.
net_auto = true

#* Sync net up/down scaling.
net_sync = true

#* Starting network interface.
net_iface = ""

#* Bitrate base.
base_10_bitrate = "Auto"

#* Show battery stats.
show_battery = true

#* Battery to display.
selected_battery = "Auto"

#* Show battery watts.
show_battery_watts = true

#* Log level.
log_level = "WARNING"

#* Save config on exit.
save_config_on_exit = false
```

## Thèmes

Les thèmes personnalisés se placent dans `~/.config/btop/themes/`. La configuration peut être rechargée à chaud avec `Ctrl + r`, sans redémarrer btop.
