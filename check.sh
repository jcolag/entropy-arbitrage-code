#!/bin/sh

# Get the date or other prefix
day=$(date +'%Y-%m-%d')
files="${HOME}/code/entropy-arbitrage-code/_posts/${day}*.md"
if [ ".$1." != ".." ]
then
  files=$*
fi

if case $(echo "${files}" | tr '*' '#') in *#*) ;; *) false;; esac; then
  exit
fi

echo "${files}"
mv "${HOME}/proselintrc.bk" "${HOME}/.proselintrc"
for file in ${files}
do
  outfile=$(mktemp).json
  proselint --json "${file}" | jq .data.errors > "${outfile}"
  java -jar "${HOME}/bin/LanguageTool-5.2-stable/languagetool-commandline.jar" \
    --disablecategories TYPOGRAPHY \
    --encoding utf-8 --json --language en-US --xmlfilter \
    "${file}" | jq .matches >> "${outfile}"
  pluma "${outfile}"
done

mv "${HOME}/.proselintrc" "${HOME}/proselintrc.bk"

