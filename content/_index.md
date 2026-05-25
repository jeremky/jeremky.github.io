---
layout: "hextra-home"
---

{{< hextra/hero-container >}}
  <div class="hx:mt-6 hx:mb-6">
  {{< hextra/hero-headline >}}
  JeremKy Docs
  {{< /hextra/hero-headline >}}
  </div>

  <div class="hx:mt-6 hx:mb-6">
  {{< hextra/hero-subtitle >}}
  Infos et documentation autour du déploiement d’applications auto-hébergées
  {{< /hextra/hero-subtitle >}}
  </div>

  <div class="hx:mt-6 hx:mb-6">
  {{< hextra/hero-button text="C'est parti !" link="docs/" >}}
  </div>
{{< /hextra/hero-container >}}

<div class="hx:mt-6 hx:mb-6">
{{< hextra/feature-grid cols="3" >}}
  {{< hextra/feature-card
    title="Conteneurisation"
    subtitle="Installation et utilisation de Docker, Podman… Des procédures pour héberger une multitude d'applications en auto-hébergement."
    link="/docs/docker"
    icon="server"
  >}}

  {{< hextra/feature-card
    title="Administration Linux"
    subtitle="Bash, Vim, SSH… Des outils et des configurations pour améliorer votre productivité en ligne de commande."
    link="/docs/linux"
    icon="terminal"
  >}}

  {{< hextra/feature-card
    title="Informations"
    subtitle="Des articles concernant ce site web, ainsi que quelques réflexions sur des décisions techniques personnels."
    link="/blog"
    icon="pencil"
  >}}
{{< /hextra/feature-grid >}}

<div class="hx:mt-6 hx:mb-6">
{{< hextra/hero-section >}}
  </br>
  Modifications récentes
{{< /hextra/hero-section >}}

{{< docs >}}

<div class="hx:mt-6 hx:mb-6">
{{< hextra/hero-section >}}
  </br>
Derniers articles
{{< /hextra/hero-section >}}

{{< posts >}}
