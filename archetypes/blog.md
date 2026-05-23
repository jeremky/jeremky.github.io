---
title: "{{ .Name | replaceRE "^\\d{4}-\\d{2}-\\d{2}-" "" | replaceRE "-" " " | humanize }}"
slug: {{ .Name | replaceRE "^\\d{4}-\\d{2}-\\d{2}-" "" }}
date: {{ .Date }}
toc: false
tags:
  - infos
draft: true
lastmod: {{ now.Format "2006-01-02" }}
---
