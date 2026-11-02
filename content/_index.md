---
layout: "hextra-home"
---

{{< hextra/hero-container >}}
  <div class="hx:mt-6 hx:mb-6 hx:w-full">
  {{< hextra/hero-headline >}}
  JeremKy Docs
  {{< /hextra/hero-headline >}}
  </div>

  <div class="hx:mt-6 hx:mb-6 hx:w-full">
  {{< hextra/hero-subtitle >}}
  Infos et documentation autour du déploiement d’applications
  {{< /hextra/hero-subtitle >}}
  </div>

  <div class="hx:mt-6 hx:mb-6 hx:w-full">
  {{< hextra/hero-button text="C'est parti !" link="docs/" >}}
  </div>
{{< /hextra/hero-container >}}

<div class="hx:mt-6 hx:mb-6 hx:w-full">
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
    title="Applications"
    subtitle="Zed, Ghostty… Différentes applications multi plateforme pour augmenter votre productivité."
    link="/docs/applications"
    icon="pencil"
  >}}
{{< /hextra/feature-grid >}}
</div>

<div class="hx:mt-6 hx:mb-6 hx:w-full">
{{< hextra/hero-section >}}
  </br>
  Modifications récentes
{{< /hextra/hero-section >}}

{{< docs >}}
</div>
