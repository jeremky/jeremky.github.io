#!/bin/bash -e

dir=$(dirname "$(realpath "$0")")

if ! command -v hugo &>/dev/null; then
  echo "Hugo n'est pas installé"
  exit 1
fi

case "$1" in
  doc)
    if [[ -z "$2" ]]; then
      echo "Usage : hugo doc <titre>"
      exit 1
    fi
    (cd "$dir" && hugo new "docs/${2}/index.md")
    ;;
  blog)
    if [[ -z "$2" ]]; then
      echo "Usage : hugo blog <nom-article>"
      exit 1
    fi
    (cd "$dir" && hugo new "blog/$(date +%Y-%m-%d)-${2}/index.md")
    ;;
  mod)
    hugo mod get -u
    ;;
  pub)
    (cd "$dir" && git add -A && git commit -m "Update" && git push)
    ;;
  version)
    hugo version
    ;;
  "")
    (cd "$dir" && hugo server --buildDrafts --buildFuture --navigateToChanged --openBrowser)
    ;;
  *)
    echo "Commande inconnue : $1"
    exit 1
    ;;
esac
