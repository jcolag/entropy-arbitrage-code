#!/bin/bash
target=/remote/path
JEKYLL_ENV="production"
now=$(date '+%s')
files=

# Ensure tag folder exists and remove existing tag files
mkdir -p tag
rm tag/*.md

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

# Commit any changes in released posts
cd _posts
for file in $files
do
  ff=$(echo $file | cut -f2 -d'/')
  git add $ff
done
git commit -m "Automated updates: $(date '+%Y-%m-%d')"
git push
cd ..

# Generate tags from released posts
#  NB: $files is unquoted, because it's a list to be split
# shellcheck disable=SC2086
for tag in $(grep '^tags:' $files | cut -f2- -d'[' | cut -f1 -d']' | tr -d ' ' | tr ',' '\n' | sort -u)
do
  cat > "tag/${tag}.md" <<EOF
---
layout: tagpage
permalink: /tag/${tag}/
tag: ${tag}
title: "Tag: ${tag}"
---
EOF
done

# Rebuild and push files
bundle exec jekyll clean
bundle exec jekyll build
rsync --itemize-changes --recursive --compress --times --delete-delay \
    _site/ "$target"
JEKYLL_ENV=

# Announce to Mastodon and Diaspora
## Get the files to be posted between the last build and now
lastbuild=$(date --date="$(cat .lastbuild)" "+%s")
now=$(date '+%s')
todayfiles=
for file in _posts/2*.md
do
  dateline=$(grep '^date:' "$file" | head -1 | cut -f2 -d':' | cut -f2 -d' ' | cut -c1-10)
  dd=$(date -d "$dateline" '+%s')
  if [ "$dd" -ge "$lastbuild" ] && [ "$dd" -le "$now" ]
  then
    todayfiles="$todayfiles $file"
  fi
done
## Get the metadata for each needed post
titles=
links=
host=$(grep "^url:" _config.yml | cut -f2 -d'"')
baseurl=$(grep "^baseurl:" _config.yml | cut -f2 -d'"')
for file in ${todayfiles}
do
  title=$(grep "^title:" ${file} | cut -f2- -d' ')
  path=$(basename ${file} .md | sed 's/-/\//g;s/\//-/g4')
  url="${host}${baseurl}/${path}.html"
  titles="${titles} ${title} ${url}"
  links="${links} [${title}](${url})"
done
## If we have posts, announce them
if [ ! -z "$titles" ]
then
  toot "Just posted to my blog:${titles}"
  ## I can't get diclish to work, so Diaspora will be manual for now
  echo "Post this to Diaspora:"
  echo "Posted to my blog:${links}"
fi

# Update timestamp
rm -f .lastbuild
date '+%F %T' > .lastbuild

# Kick off the local server
bundle exec jekyll serve --future --drafts --unpublished

