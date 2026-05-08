---
title: "Le site déménage...encore"
slug: le-site-demenage-encore
date: 2026-05-08T10:03:14+02:00
useRelativeCover: true
cover: cover.webp
tags:
  - infos
categories:
  - News
toc: true
draft: false
---

Depuis sa création, ce blog a pas mal été déplacé sur différentes plateformes. Hébergement local via Hugo sur NGinx, passage par le [CMS Ghost](/posts/deploiement-du-cms-ghost-avec-docker/), [retour sur Hugo](/posts/retour-sur-le-generateur-de-site-hugo/), [déménagement](/posts/demenagement-du-site/) vers GitHub Pages... Et maintenant, il bascule cette fois-ci sur le service Codeberg Pages.

## Pourquoi ce changement ?

Un article devrait arriver dans les prochaines semaines à ce sujet, mais il s'avère que j'ai pris la décision de me séparer des services proposés par Microsoft. Depuis leur rachat de GitHub, pas mal de changements politiques ont eu lieu... Et les polémiques de ces dernières semaines ont enfoncé le clou.

GitHub [se sert de vos données pour entraîner ses modèles d'IA](https://www.numerama.com/cyberguerre/2220443-github-fait-machine-arriere-et-va-bien-entrainer-ses-ia-sur-vos-donnees.html), [insère de la publicité dans vos pull requests](https://www.programmez.com/actualites/github-des-pubs-dans-github-oui-mais-pour-nous-aider-39237) (même si Microsoft est apparemment revenus en arrière à ce sujet). Je vous laisse également consulter [cet excellent article](https://www.cridutroll.fr/github-est-en-train-de-mourir-pourquoi-meme-les-legendes-du-dev-fuient-la-plateforme/) qui explique les déboires de ces dernières semaines.

## Pour aller où ?

Il existe plusieurs alternatives, mais j'ai finalement pris la décision de migrer vers [Codeberg](https://codeberg.org/). C'est un projet communautaire à but non lucratif qui a pour but de fournir un service git similaire à ce que propose GitHub, GitLab... Ils n'ont donc pas la même infrastructure, mais ils ont comme avantage d'être situés en Europe (plus précisément en Allemagne), et non aux États-Unis. Ce manque de moyens va donc se ressentir dans les performances du site, mais je n'ai pas non plus un trafic conséquent, donc ça devrait largement suffire.

J'ai quand même hésité à reprendre la gestion de l'hébergement. Mais comme dit dans [cet article](/posts/edito-mise-en-pause-de-auto-hebergement/) au sujet de ma mise en pause de l'auto-hébergement, je ne me voyais pas repayer pour un nom de domaine couplé à un VPS pour si peu. Ce site n'est qu'une petite base de consultation pour les copains, et l'idée reste de limiter les coûts autant que possible.

## C'est quoi alors le nouveau lien ?

Le site est donc désormais accessible au lien suivant : <https://jeremky.codeberg.page>. C'était d'ailleurs l'occasion de renommer le site en "JeremKy Pages".

J'en profite pour préciser que tous mes modestes projets sont quant à eux déjà supprimés de GitHub et hébergés sur Codeberg. Les liens dans les différents articles ont été mis à jour en conséquence. Vous pouvez retrouver la liste des projets [ici](https://codeberg.org/jeremky).

Une bannière sur <https://jeremky.github.io> informera les arrivants de la migration. Je pense conserver le site sur GitHub encore un mois ou deux, histoire de m'assurer que la transition se passe correctement.

On se retrouve [là-bas](https://jeremky.codeberg.page) :blush:
