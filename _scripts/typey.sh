#!/bin/bash
unsnap="unsnappy"
site=https+++didoesdigital.com
user_home=$(bash -c "cd ~$(printf "$(whoami)") && pwd")
tempdb=$(mktemp --suffix=.sqlite)
temp=$(mktemp)
profile=$(grep '^Default=' ~/.mozilla/firefox/profiles.ini | head -1 | cut -f2- -d'=')
cp "${user_home}/.mozilla/firefox/${profile}/storage/default/${site}/ls/data.sqlite" "${tempdb}"

wpm=$(sqlite3 "${tempdb}" "SELECT value FROM data WHERE key = 'topSpeedPersonalBest';" | jq -r .wpm)
sqlite3 "${tempdb}" "SELECT value FROM data WHERE key = 'topSpeedPersonalBest';"
sqlite3 "${tempdb}" "SELECT hex(value) FROM data WHERE key = 'lessonsProgress';" | ${unsnap} | jq .
sqlite3 "${tempdb}" "SELECT hex(value) FROM data WHERE key = 'metWords';" | ${unsnap} | jq .
sqlite3 "${tempdb}" "SELECT hex(value) FROM data WHERE key = 'recentLessons';" | ${unsnap} | jq .
# sqlite3 "${tempdb}" "SELECT hex(value) FROM data WHERE key = 'userSettings';" | ${unsnap} | jq .

rm "${tempdb}"


