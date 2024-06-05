#!/bin/bash
day=0
max=7
if [ $# -ge 1 ]
then
  max=$1
fi
date -d "+${max} days"
gedit _sass/minima.scss
gedit _drafts/*.md
while [ "$day" -le "$max" ]
do
  dd=$(date --date "+${day} days" +%F)
  file=$(ls -1 _posts/"${dd}"-*.md 2> /dev/null)
  if [ -n "$file" ]
  then
    gedit "$file"
    sleep 0.3
  fi
  day=$((day + 1))
done
