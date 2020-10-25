#!/bin/bash
day=0
max=7
if [ $# -ge 1 ]
then
  max=$1
fi
pluma _sass/minima.scss
while [ $day -le $max ]
do
  dd=$(faketime -f "+${day}d" date +%F)
  file=$(ls -1 _posts/${dd}-*.md 2> /dev/null)
  if [ ! -z $file ]
  then
    pluma $file
    sleep 1
  fi
  day=$((day + 1))
done
