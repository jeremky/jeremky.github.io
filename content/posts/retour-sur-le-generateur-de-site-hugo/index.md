---
title: Retour sur le générateur de site Hugo
date: 2024-07-17T15:25:38Z
useRelativeCover: true
cover: cover.webp
tags:
    - infos
categories:
    - News
toc: false
draft: false
---

Le site [jeremky.github.io](https://jeremky.github.io) est de nouveau généré par le framework [Hugo](https://gohugo.io) !

## Le CMS Ghost

Depuis quelques mois, ce site web fonctionnait sur le CMS [Ghost](https://ghost.org). OpenSource, Ghost a été créé par des anciens développeurs de Wordpress qui voulaient produire une solution plus légère, et plus orientée blog. C'est à mes yeux une promesse réussie, car même si les possibilités sont réduites, ce CMS est plutôt pertinent dans son approche. Son interface d'administration est claire, la rédaction des articles se fait efficacement.

Cependant, il n'est pas sans défaut :
- Ghost repose sur le moteur NodeJS. C'est performant, mais cela réduit le nombre d'hébergeurs (qui proposent le plus souvent PHP)
- Il dépend d'une base de données MySQL. En soi, rien de problématique, mais la consommation de la mémoire vive du serveur est, je trouve, assez élevée

## Go Hugo !

Cette décision de revenir sur Hugo est en lien avec [l'article du mois dernier](/posts/informations-au-sujet-du-site/). Je souhaite réduire les coûts et optimiser les outils et applications en place autant que possible.

[OVH](https://www.ovhcloud.com/fr/), le fournisseur de services utilisé, propose gratuitement un espace d'hébergement Web aux clients ayant acheté un nom de domaine chez eux. Cet espace est restreint, et ne propose pas de base de données. 

Mais combiné au générateur de sites statiques Hugo, c'est une solution pertinente. Le site n'est pas dépendant des ressources du serveur où se trouvent les applications, et cela apporte plus de flexibilité en cas de redémarrage, car non dépendant du proxy en place.

Et la génération des pages se faisant en amont, la réactivité est toujours au rendez-vous même si les performances sont moindres.

L'écriture des pages se fait en [Markdown](https://fr.wikipedia.org/wiki/Markdown). A utiliser, c'est évidemment moins confortable qu'avec une interface dédiée à la rédaction, mais ce n'est pas comme si je sortais un article tous les jours... :smile:

## Le site

De nouveaux articles arriveront courant de l'été, sur comment installer le CMS [Ghost](https://ghost.org/) via Docker, et comment installer et utiliser l'application [Resilio Sync](https://www.resilio.com/individuals/).

Je vous souhaite de bonnes vacances !
