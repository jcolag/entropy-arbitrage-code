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

This script rebuilds the blog's tags.
"
    exit
fi

now=$(date '+%s')
files=

# Collect posts that should already be released
for file in _posts/2*.md
do
  dateline=$(grep '^date:' "$file" | head -1 | cut -f2 -d':' | cut -f2 -d' ' | cut -c1-10)
  dd=$(date -d "$dateline" '+%s')
  if [ "$dd" -lt "$now" ]
  then
    files="$files $file"
  fi
done

# Ensure tag folder exists and remove existing tag files
mkdir -p tag
rm -f tag/*.md

# Generate tags from released posts
#  NB: $files is unquoted, because it's a list to be split
# shellcheck disable=SC2086
for tag in $(grep '^tags:' $files | cut -f2- -d'[' | cut -f1 -d']' | tr -d ' ' | tr ',' '\n' | sort -u | tr -s ' ' | tr ' ' ':')
do
  if [[ "${tag}" =~ "-" ]]
  then
    tagname="${tag}"
    tag=$(echo "${tag}" | tr -d '-')
    cat > "tag/${tagname}.md" <<EOF
---
layout: tagalias
permalink: /tag/${tagname}
tag: ${tagname}
destination: ${tag}
---
EOF
  else
    tagname=$(echo "${tag}" | cut -f3 -d':')
    desc=$(yq -r ".${tagname}" < _taginfo.yml)
    cat > "tag/${tagname}.md" <<EOF
---
layout: tagpage
permalink: /tag/${tagname}/
tag: ${tagname}
title: Tag- ${tagname}
count: 0
description: ${desc}
---
EOF
  fi
done

cat > "tag/index.html" <<EOF
<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <link rel="shortcut icon" href="/blog/assets/jc.ico" />
        <link rel="stylesheet" href="/blog/assets/main.css">
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="0; url=/blog/tags/">
        <script type="text/javascript">
            window.location.href = "/blog/tags/"
        </script>
        <title>Redirection from {{ page.tag }} to {{ page.destination }}</title>
    </head>
    <body>
        If you are not redirected automatically, follow this
        <a href='/blog/tags/'>link to the {{ page.destination }} page</a>.
    </body>
</html>
EOF

