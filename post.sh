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
file=$(ls -1 "${HOME}"/code/entropy-arbitrage-code/_posts/"${day}"*.md)

if [ ".${1-}." != ".." ]
then
  file=$*
fi

summary=$(grep '^summary: ' "${file}" | head -1 | cut -f2- -d':' | sed 's/^ *//g')
tags=$(grep '^tags: ' "${file}" | head -1 | cut -f2 -d'[' | cut -f1 -d']' | sed 's/, / #/g')
teaser=$(grep '^teaser: ' "${file}" | head -1 | cut -f2- -d':' | sed 's/^ *//g')
title=$(grep '^title: ' "${file}" | head -1 | cut -f2- -d':' | sed 's/^ *//g')
cat=$(grep '^categories:' "${file}" | head -1 | cut -f2- -d':' | sed 's/^ *//g')

path=$(basename "${file}" .md | sed 's/-/\//g;s/\//-/g4')
url="${host}${baseurl}${cat}/${path}.html"

echo "New Blog Post - ${title}"
echo
echo "${title}: ${summary}"
echo "${url}"
echo "${teaser}"
echo "#${tags}"

