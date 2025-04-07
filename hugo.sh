#!/bin/bash
set -e

# Commandes
case $1 in
n | new)
  hugo new posts/$2.md
  mkdir -v static/img/posts/$2
  ;;
s | srv)
  hugo server -D
  ;;
*)
  hugo --cleanDestinationDir
  ;;
esac
