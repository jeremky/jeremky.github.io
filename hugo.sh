#!/bin/bash -e

dir=$(dirname "$(realpath "$0")")

if ! command -v hugo &>/dev/null; then
  echo "Hugo n'est pas installé"
  exit 1
fi

case "$1" in
  doc)
    if [[ -z "$2" ]]; then
      echo "Usage : hugo doc <repertoire>"
      exit 0
    fi
    (cd "$dir" && hugo new "docs/${2}/index.md")
    ;;
  blog)
    if [[ -z "$2" ]]; then
      echo "Usage : hugo blog <nom-article>"
      exit 0
    fi
    (cd "$dir" && hugo new "blog/$(date +%Y-%m-%d)-${2}/index.md")
    ;;
  version)
    hugo version
    ;;
  *)
    (cd "$dir" && hugo server --buildDrafts --buildFuture --navigateToChanged --openBrowser)
    ;;
esac
