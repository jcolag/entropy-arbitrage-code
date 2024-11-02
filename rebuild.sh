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

This script rebuilds the blog and publishes the update.
"
    exit
fi

target=jcolag@colagioia.net:www/blog
toot="toot"
twtxt="twtxt"
matrix="~/bin/matrix.sh"
# diclish="diclish"
JEKYLL_ENV="production"
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

# Commit any changes in released posts
cd _posts || exit
for file in $files
do
  ff=$(echo "$file" | cut -f2 -d'/')
  git add "$ff"
done
git commit -m "Automated updates: $(date '+%Y-%m-%d')"
git push
git push disroot
cd ..

./tags.sh

# Rebuild and push files
### Resize all images to the blog width
#mogrify -resize $maxwd\> assets/*.jpg
#mogrify -resize $maxwd\> assets/*.png
## Clean out the unneeded backup files
rm -f assets/*~
rm -f .jekyll-cache/github.yml
cat > .jekyll-cache/github.yml <<EOF
---
- nothing/nothing: 
EOF
## Rebuild the blog
# bundle exec jekyll clean
JEKYLL_ENV=production bundle exec jekyll build
## Push to the server
rsync --checksum --itemize-changes --recursive --compress --times --delete-delay \
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
  title=$(grep "^title:" "${file}" | cut -f2- -d' ')
  tags=$(grep "^tags:" "${file}" | cut -f2 -d'[' | cut -f1 -d']' | tr -d ',-' | sed 's/\([a-z]*\)/#\1/g')
  teasers=$(grep "^description:" "${file}" | cut -f2- -d' ')
  cat=$(grep '^categories:' "${file}" | cut -f2 -d':' | tr -d ' ')
  if [ -n "$cat" ]
  then
    cat="/${cat}"
  fi
  path=$(basename "${file}" .md | sed 's/-/\//g;s/\//-/g4')
  url="${host}${baseurl}${cat}/${path}.html"
  titles="${titles} ${title} ${url}"
  links="${links} [${title}](${url})"
done
## If we have posts, announce them
if [ -n "$titles" ]
then
  ### Mastodon
  thumb=$(grep '^thumbnail: ' "${file}" | cut -f2 -d' ' | sed 's/\/blog\//_e/g')
  desc=$(grep '^!\[' "${file}" | cut -f2 -d'[' | cut -f1 -d']')
  if ${toot} auth | grep -q ACTIVE
  then
    echo Already logged in to Mastodon.
  else
    ${toot} login_cli
  fi
  ${toot} post --media "${thumb}" --description "${desc}" "On my blog:${titles} - ${teasers} ${tags}"
  ### twtxt
  ${twtxt} tweet "On my blog:${titles} ${tags}"
  ### Matrix
  ${matrix} "${titles} posted - ${teasers}"
  ### I can't get diclish to work, so Diaspora will be manual for now
  ### And honestly, at this point, I have probably alread posted everywhere
  ### using the post.sh script to generate the blurb for everywhere that
  ### didn't automatically happen above.
  # echo "Post this to Diaspora:"
  # ntfy send "Post to Diaspora..."
  # aplay /usr/share/sounds/sound-icons/prompt.wav
  # echo -e "On my blog: ${links}\n${teasers}\n${tags}"
  # echo -e "On my blog: ${links}\n${teasers}\n${tags}" | xsel --clipboard
fi

# Update timestamp
rm -f .lastbuild
date '+%F %T' > .lastbuild

now=$(date +%s)
count=$(for i in $(grep '^date: ' _posts/2*.md | cut -f3- -d':' | cut -c2- | sed 's/ /T/g')
do
  published=$(date --date="${i}" +%s)
  echo $((published - now))
done | grep -c '-')
echo "Current count of published posts: ${count}"
ntfy send "Current count of published posts: ${count}"

# Send webmentions
# Already happened with the plugin?
# bundle exec jekyll webmention

# Kick off the local server
bundle exec jekyll serve --future --drafts --unpublished --trace --incremental

