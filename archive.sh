#!/bin/sh
dom=$(date +%_d)
if [ "${dom}" -gt 7 ] || [ ".$(date +%a)." != .Sat. ]
then
  exit 0
fi
server=$(grep '^url: ' _config.yml | cut -f2 -d'"')
path=$(grep '^baseurl: ' _config.yml | cut -f2 -d'"')
sitemap="${server}${path}/sitemap.xml"
local=$(mktemp --suffix=.xml)

curl "${sitemap}" > "${local}"
if [ ".$1." != ".." ]
then
  local=$*
fi

for link in $(xmllint --format "${local}" | grep '<loc>' | cut -f2- -d'>' | cut -f1 -d'<')
do
  echo "${link}"
  curl -s "https://web.archive.org/save/${link}"
  sleep 6
done

