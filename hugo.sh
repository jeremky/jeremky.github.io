#!/bin/bash -e

dir=$(dirname "$(realpath "$0")")

# Vérification de la présence de Hugo
if ! command -v hugo &>/dev/null; then
  echo "Hugo n'est pas installé"
  exit 1
fi

# Exécution
case "$1" in
  new)
    if [[ -z "$2" ]]; then
      echo "Usage : hugo new <nom-article>"
      exit 0
    fi
    date=$(date +%Y-%m-%d)
    (cd "$dir" && hugo new "posts/${date}-${2}/index.md")
    ;;
  version)
    (hugo version)
    ;;
  *)
    (cd "$dir" && hugo server -D)
    ;;
esac
