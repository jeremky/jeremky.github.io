#!/bin/bash -e

dir=$(dirname "$(realpath "$0")")
run() { (cd "$dir" && "$@"); }

if ! command -v hugo &>/dev/null; then
  echo "Hugo is not found"
  exit 1
fi

case "$1" in
  mod)
    run hugo mod get -u
    ;;
  new)
    if [[ -z "$2" ]]; then
      echo "Usage : hugo new <title>"
      exit 1
    fi
    run hugo new "docs/${2}/index.md"
    ;;
  push)
    run git add -A
    run git commit -m "Update"
    run git push
    ;;
  version)
    hugo version
    ;;
  "")
    run hugo server --buildDrafts --buildFuture --navigateToChanged --openBrowser
    ;;
  *)
    echo "Unknown Command: $1"
    exit 1
    ;;
esac
