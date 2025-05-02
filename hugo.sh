#!/bin/bash -e

# Commandes
case $1 in
n | new)
  hugo new posts/$2/index.md
  ;;
s | srv)
  hugo server -D
  ;;
*)
  hugo --cleanDestinationDir
  ;;
esac
