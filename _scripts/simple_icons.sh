#!/bin/sh
script=$(readlink -f "${0}")
here=$(dirname "${script}")
repo=simple-icons/simple-icons-font
where=/tmp/
url=$(curl --silent "https://api.github.com/repos/${repo}/releases/latest" | jq -r '.assets[].browser_download_url')
file=$(echo "${url}" | rev | cut -f1 -d'/' | rev)
dir="${where}$(basename "${file}" .zip)"
wget --quiet --directory-prefix="${where}" "${url}"
mkdir "${dir}"
unzip -qq -n "${where}/${file}" -d "${dir}"

css=$(find "${dir}" -name "*.css" -print | grep -v '\.min\.css')
ruby "${here}/link_annotation_update.rb" --mapping "${here}/../_plugins/simpleicons.yml" --prefix si --stylesheet "${css}"

rm -rf "${dir}" "${where}/${file}"

