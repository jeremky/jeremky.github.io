---
title: Déménagement du site
slug: demenagement-du-site
date: 2025-03-24T18:27:50+01:00
useRelativeCover: true
cover: cover.webp
tags:
  - infos
categories:
  - News
toc: false
draft: false
---

Cela fait maintenant plusieurs semaines que je me pose la question de la pertinence de garder les différents services que j'utilise chez OVH (Serveur auto hébergé, nom de domaine...). Je me suis également demandé comment faire le jour où éventuellement, je dépasse les pauvres 100 Mo proposés par le service gratuit d'hébergement pour ce site.

Après avoir fait un peu de recherche, je suis tombé sur le service proposé par GitHub, [GitHub Pages](https://pages.github.com/), qui permet de mettre en ligne gratuitement des sites Web statiques, avec une limitation de taille bien plus confortable.

Le renouvellement du nom de domaine arrivant pour Août, je me suis donc lancé dans différents tests du service de GitHub et j'ai été directement séduit par l'efficacité de leur solution, pour les raisons suivantes :

- Restrictions de stockage bien moins contraignantes
- Possibilité de récupérer les sources de n'importe où via git
- Compilation du site directement chez eux, via [GitHub Actions](https://github.com/features/actions) dès que l'on pousse les modifications
- Certificat SSL officiel, donc pas besoin d'utiliser Let's Encrypt, dont les certificats sont parfois refusés par certains proxy

C'est donc officiel, le site sera désormais [JeremKy.github.io](https://jeremky.github.io) !

Je pense laisser l'ancienne version active jusqu'à la fin de l'engagement pour le nom de domaine actuel, le temps aux (quelques) auditeurs d'avoir l'information.

Bisous !
