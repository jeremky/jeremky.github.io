---
title: {{ replace .Name "-" " " | title }}
date: {{ .Date }}
cover: /posts/{{ .File.ContentBaseName }}/cover.webp
tags:
  - docker
  - podman
categories:
  - Tutos
toc: true
draft: true
---

