#!/bin/bash

# Boilerplate
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR
_ME="$(basename "${0}")"

if [[ "${TRACE-0}" == "1" ]]
then
  set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]
then
    echo "Usage: ${_ME} [filename]

This script will assemble a quick social media post for either the provided
blog post or the current day's post, if not specified.
"
    exit
fi

host=$(grep "^url:" _config.yml | cut -f2 -d'"')
baseurl=$(grep "^baseurl:" _config.yml | cut -f2 -d'"')
day=$(date +'%Y-%m-%d')

if [ ".${1-}." != ".." ]
then
  file=$*
elif test -f "${HOME}"/code/entropy-arbitrage-code/_posts/"${day}"*.md
then
  file=$(ls -1 "${HOME}"/code/entropy-arbitrage-code/_posts/"${day}"*.md)
else
  echo No relevant file found.
  exit 1
fi

summary=$(grep '^summary: ' "${file}" | head -1 | cut -f2- -d':' | sed 's/<[^>]*>//g;s/^ *//g')
tags=$(grep '^tags: ' "${file}" | head -1 | cut -f2 -d'[' | cut -f1 -d']' | sed 's/, / #/g;s/-\([a-z]\)/\U&/g;s/-//g')
teaser=$(grep '^description: ' "${file}" | head -1 | cut -f2- -d':' | sed 's/^ *//g')
title=$(grep '^title: ' "${file}" | head -1 | cut -f2- -d':' | sed 's/^ *//g')
cat=$(grep '^categories:' "${file}" | head -1 | cut -f2- -d':' | sed 's/^ *//g')
thumb=$(grep 'thumbnail: ' "${file}" | cut -f3- -d'/' | sed 's/^/_e/g')

path=$(basename "${file}" .md | sed 's/-/\//g;s/\//-/g4')
url="${host}${baseurl}${cat}/${path}.html"

echo "New Blog Post - ${title}"
echo
echo "${title}: ${summary}"
echo "${url}"
echo "${teaser}"
echo
echo "[${title}](${url}): ${summary}"
echo
echo "${teaser}"
echo
echo "#${tags}"

weekday=$(date "+%w")
if [ $weekday -ne 5 ]
then
  cp "$thumb" ~/Downloads
fi

recovery=$(find ~/.mozilla/firefox -name "recovery.jsonlz4" -print)
tabs=$(lz4jsoncat "${recovery}" | jq -r .windows[].tabs[].entries[0].url)

if grep -q 'buymeacoffee.com' <<< "${tabs}"
then
  echo Already open!
else
  xdg-open https://www.buymeacoffee.com/app/dashboard
fi

xdg-open https://nota.404.mn/stream
xdg-open https://spoutible.com/
xdg-open https://pinkary.com/
xdg-open https://sez.us/
xdg-open https://fe.disroot.org/

