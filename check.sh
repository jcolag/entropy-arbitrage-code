#!/bin/sh

# Get the date or other prefix
day=$(date +'%Y-%m-%d')
files=$(ls -1 "${HOME}"/code/entropy-arbitrage-code/_posts/"${day}"*.md 2> /dev/null)
if [ ".$1." != ".." ]
then
  files=$*
fi

if case $(echo "${files}" | tr '*' '#') in *#*) ;; *) false;; esac; then
  exit
fi

echo "${files}"
mv "${HOME}/proselintrc.bk" "${HOME}/.proselintrc.json"
for file in ${files}
do
  outfile=$(mktemp).json
  proselint --json "${file}" | jq .data.errors >> "${outfile}"
  java -jar "${HOME}/bin/LanguageTool-5.2-stable/languagetool-commandline.jar" \
    --disablecategories TYPOGRAPHY \
    --encoding utf-8 --json --language en-US --xmlfilter \
    "${file}" | node "${HOME}/code/entropy-arbitrage-code/_plugins/languagetool.js" "${file}" >> "${outfile}"
  rm map.json
  write-good --no-adverb --no-tooWordy --no-weasel --parse "${file}" | node "${HOME}/code/entropy-arbitrage-code/_plugins/write-good.js" >> "${outfile}"
  alex --why --reporter="${HOME}/code/entropy-arbitrage-code/_plugins/alex-formatter.js" "${file}" >> "${outfile}" 2>&1
done

mv "${HOME}/.proselintrc.json" "${HOME}/proselintrc.bk"

