---
title: "{{ .Name | replaceRE "-" " " | humanize }}"
slug: {{ .Name }}
contextMenu: true
weight: 10
toc: true
tags:
  - linux
draft: true
lastmod: {{ now.Format "2006-01-02" }}
---
