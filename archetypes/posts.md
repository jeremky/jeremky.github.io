---
title: "{{ .Name | replaceRE "^\\d{4}-\\d{2}-\\d{2}-" "" | replaceRE "-" " " | humanize }}"
slug: {{ .Name | replaceRE "^\\d{4}-\\d{2}-\\d{2}-" "" }}
date: {{ .Date }}
useRelativeCover: true
cover: cover.webp
tags:
  - linux
categories:
  - Tutos
toc: true
draft: true
---
