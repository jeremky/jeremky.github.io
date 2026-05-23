---
title: "Utilisation de Homebrew"
slug: utilisation-de-homebrew
weight: 10
contextMenu: true
toc: true
tags:
  - macos
draft: false
lastmod: 2026-05-17
---

[Homebrew](https://brew.sh/fr/) est un **gestionnaire de paquets** pour macOS (il existe aussi une version pour Linux, bien que moins couramment utilisée). Si vous êtes familier avec Linux, vous connaissez probablement `apt` (Debian/Ubuntu) ou `dnf` (Fedora/RHEL). Sous Windows, il existe `winget` ou `chocolatey`. Homebrew joue exactement ce rôle sous macOS : c'est un outil qui simplifie l'installation, la mise à jour et la suppression de logiciels et d'outils en ligne de commande.

## Pourquoi utiliser Homebrew ?

Avant Homebrew, installer un logiciel sous macOS se faisait soit en téléchargeant un `.dmg` depuis un navigateur et en le glissant dans Applications, soit en compilant des sources. C'est fastidieux et peu maintenable.

Avec Homebrew, vous tapez simplement :

```bash
brew install <application>
```

Et c'est tout. Homebrew gère les dépendances, les mises à jour, et le nettoyage automatiquement.

Homebrew propose deux types de paquets :

- **Formulas** : des outils en ligne de commande (git, vim, wget, etc.)
- **Casks** : des applications graphiques (Firefox, Discord, etc.)

## Installation

L'installation de Homebrew est très simple. Il suffit d'exécuter la commande suivante :

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Une fois l'installation terminée, Homebrew vous demandera probablement d'ajouter le répertoire de Homebrew à votre `PATH`. Sur les Mac avec Apple Silicon (M1, M2, M3, etc.), Homebrew s'installe généralement dans `/opt/homebrew/bin`. Sur les anciens Mac Intel, c'est `/usr/local/bin`.

Vous pouvez vérifier que tout fonctionne correctement avec :

```bash
brew --version
```

> [!NOTE]
> Homebrew nécessite les Command Line Tools d'Xcode. L'installateur vous proposera de les installer si nécessaire

## Configuration

Par défaut, Homebrew fonctionne sans configuration. Cependant, il est recommandé d'ajuster quelques paramètres pour une meilleure expérience.

### Variables d'environnement utiles

Ajoutez ceci à votre fichier `.zsh_aliases` (ou `.zshrc`) :

```bash
# Variables Brew
if [[ -f /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_NO_ANALYTICS=1
fi
```

Pour les appareils encore sous Intel :

```bash
# Variables Brew
if [[ -f /usr/local/bin/brew ]]; then
  export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_NO_ANALYTICS=1
fi
```

**Explications** :

- `HOMEBREW_NO_ENV_HINTS=1` : désactive les messages d'avertissement concernant le `PATH`
- `HOMEBREW_NO_ANALYTICS=1` : désactive l'envoi de données anonymes à Homebrew (pour ceux qui sont sensibles à la vie privée)

### Alias de mise à jour pratique

Ajoutez cet alias à votre `.zsh_aliases` pour simplifier la maintenance :

```bash
alias upgrade='brew update && brew upgrade -g && brew cleanup'
```

Cet alias exécute :

1. `brew update` : met à jour la liste des paquets disponibles
2. `brew upgrade -g` : met à jour tous les paquets installés (l'option `-g` force la mise à jour)
3. `brew cleanup` : supprime les anciennes versions et les fichiers temporaires

Dès lors, un simple `upgrade` mettra à jour tout votre système Homebrew en une seule commande.

## Utilisation

Je vous fais un tableau des commandes essentielles :

| Commande                  | Utilité                                  |
| ------------------------- | ---------------------------------------- |
| `brew install nom`        | Installer une formula                    |
| `brew install --cask nom` | Installer un cask                        |
| `brew search motclé`      | Chercher un paquet                       |
| `brew list`               | Lister les installations                 |
| `brew upgrade`            | Mettre à jour tous les paquets           |
| `brew uninstall nom`      | Désinstaller un paquet                   |
| `brew cleanup`            | Nettoyer les fichiers temporaires        |
| `brew doctor`             | Diagnostiquer les problèmes              |
| `brew autoremove`         | Supprimer les dépendances inutiles       |
| `upgrade` (alias)         | Mettre à jour + nettoyer en une commande |

### Taps et formules personnalisées

Les **taps** sont des dépôts GitHub tiers qui proposent des paquets supplémentaires. Par exemple :

```bash
brew tap <foo/bar>
brew install <application>
```

Pour lister vos taps actifs :

```bash
brew tap
```

> **Conseil** : maintenez le moins possible de taps pour éviter de surcharger votre installation. L'installation par défaut est suffisamment complète

## Brewinstall : automatiser l'installation

Jusqu'à présent, nous avons vu comment installer Homebrew et l'utiliser manuellement. Mais si vous formatez votre Mac ou configurez une nouvelle machine, installer des dizaines de paquets ligne par ligne devient très fastidieux.

C'est là qu'intervient **brewinstall** : un script perso qui automatise l'installation de brew et d'applications en masse à partir de listes.

### Script

Le script est disponible directement sur GitHub, en suivant **[ce lien](https://codeberg.org/jeremky/brewinstall)**. Pour le récupérer :

```bash
git clone https://codeberg.org/jeremky/brewinstall
```

### Fichiers de configuration (.cfg)

Les fichiers `.cfg` sont de simples fichiers texte, une application par ligne.

Exemple de `brewinstall.apps.cfg` :

```txt {filename="brewinstall.apps.cfg"}
vim
curl
wget
colordiff
```

Et de l'équivalent pour les casks, `brewinstall.cask.cfg` :

```txt {filename="brewinstall.cask.cfg"}
discord
firefox
iterm2
vlc
vscodium
```

> Les lignes vides et les commentaires (lignes commençant par `#`) sont ignorés, ce qui permet de bien organiser vos listes

### Utilisation du script

Une fois vos listes prêtes, il ne reste plus qu'à exécuter le script :

```bash
./brewinstall.sh
```

> [!NOTE]
> Votre mot de passe vous sera demandé pour désactiver la création des fichiers `.DS_Store` sur les partages réseau
